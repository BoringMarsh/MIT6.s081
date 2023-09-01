// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
  struct spinlock ref_lock;
  unsigned int *ref_count;
} kmem;

#define PA2REFINDEX(pa) (((char *)pa - (char *)PGROUNDUP((uint64)end)) >> 12)

unsigned int
get_ref_count(void *pa)
{
  return kmem.ref_count[PA2REFINDEX(pa)];
}

void
add_ref_count(void *pa)
{
  kmem.ref_count[PA2REFINDEX(pa)]++;
}

void
acquire_ref_lock()
{
  acquire(&kmem.ref_lock);
}

void
release_ref_lock()
{
  release(&kmem.ref_lock);
}

void
kinit()
{
  initlock(&kmem.lock, "kmem");
  initlock(&kmem.ref_lock, "ref_lock");
  //freerange(end, (void*)PHYSTOP);
  //printf("end: %p\n", (uint64)end);

  const uint64 USRSIZE = PHYSTOP - (uint64)end;
  const uint64 PHYPGCOUNT = (USRSIZE >> 12) + (USRSIZE % 0x1000 != 0);  //pages count
  const uint64 RCSIZE = PHYPGCOUNT * sizeof(uint);  //max size of ref_count array
  const uint64 RCPGCOUNT = (RCSIZE >> 12) + (RCSIZE % 0x1000 != 0);  //number of pages for storing ref_count array
  const uint64 RCPGSIZE = RCPGCOUNT << 12;  //size of pages storing ref_count array
  kmem.ref_count = (unsigned int*)end;  //set first address of ref_count array
  //printf("USRSIZE:    %p\n", USRSIZE);
  //printf("PHYPGCOUNT: %p\n", PHYPGCOUNT);
  //printf("RCSIZE:     %p\n", RCSIZE);
  //printf("RCPGCOUNT:  %p\n", RCPGCOUNT);
  //printf("RCPGSIZE:   %p\n", RCPGSIZE);
  
  freerange(end + RCPGSIZE, (void*)PHYSTOP);  //all physical pages except those for storing ref_count array is free
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    kmem.ref_count[PA2REFINDEX(p)] = 1;  //set 1 default is for kfree
    kfree(p);
  }
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  acquire(&kmem.lock);
  if (--kmem.ref_count[PA2REFINDEX(pa)]) {
    release(&kmem.lock);
    return;
  }
  release(&kmem.lock);

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r) {
    kmem.freelist = r->next;
    kmem.ref_count[PA2REFINDEX(r)] = 1;
  }
  release(&kmem.lock);

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}
