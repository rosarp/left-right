# This is port of jonhoo/left-right crate in zig language

## Original statement

Left-right is a concurrency primitive for high concurrency reads over a single-writer data structure. The primitive keeps two copies of the backing data structure, one that is accessed by readers, and one that is accessed by the (single) writer. This enables all reads to proceed in parallel with minimal coordination, and shifts the coordination overhead to the writer. In the absence of writes, reads scale linearly with the number of cores.
