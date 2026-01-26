# True-Dual-Port-BRAM-for-reading-two-data-simultaneously.-
A TDP BRAM provides two independent ports that can operate simultaneously. The most practical flow for this project is to build the tree first using a controlled insertion process and then switch the design into a pure search mode. During the insertion phase, only one port is used for writing so the tree structure remains consistent and avoids unintended corruption. After the ruleset is fully stored, writes are disabled and both BRAM ports are used for reading, enabling two independent read operations in the same clock window. This allows parallel search progression and becomes the foundation for a pipelined.

TDP BRAM provides:

1) Port A: Read/Write
2) Port B: Read/Write (or read-only by forcing write-enable low)

With both ports available, during the search phase I can do:
1) Use Port A for read-only
2) Use Port B for read-only

Perform two independent addresses reads per cycle
This allows me to run two search engines (two lanes) in parallel.

Two-Phase Workflow: Build Then Search
To avoid corruption of tree structure:

Phase 1: Insert 
1) Use only Port A write
2) Use normal sequential insertion FSM
Phase 2: Search
1) Freeze the tree (no writes)
2) Use both ports as read
Run parallel searches for throughput

This split guarantees:

1) No write-read clashes
2) No accidental overwriting of pointers
3) High PPS during packet processing
