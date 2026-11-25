# Synchronous FIFO in SystemVerilog

A small FIFO design and a self-checking testbench.

## Project files

- `sync_fifo.sv` - FIFO design, 8 bits wide and 8 entries by default.
- `tb_sync_fifo.sv` - testbench that checks reset, full and empty flags, FIFO order, blocked overflow and underflow, and simultaneous read/write.

## Run it in EDA Playground

1. Open https://edaplayground.com/home.
2. Under **Languages & Libraries**, choose **SystemVerilog/Verilog**.
3. Under **Tools & Simulators**, choose **Icarus Verilog 12.0**.
4. Paste `sync_fifo.sv` into the `design.sv` editor.
5. Paste `tb_sync_fifo.sv` into the `testbench.sv` editor.
6. Log in, then click **Run**. EDA Playground requires login to run or save code.
7. Look for the testbench's `PASS` message in the output.

## FIFO behavior

- `wr_en` requests a write; writes are accepted while the FIFO is not full.
- `rd_en` requests a read; reads are accepted while the FIFO is not empty.
- `dout` updates on a rising clock edge when a read is accepted.
- `rst_n` is an active-low synchronous reset.
- `DEPTH` should be a power of two for this beginner implementation (default: 8).
- If full, a write is rejected even if a read is requested in the same cycle. If empty, a read is rejected even if a write is requested in the same cycle.

## Upload to GitHub

1. Sign in to GitHub and choose **New repository**.
2. Give the repository a name such as `synchronous-fifo-systemverilog` and create it.
3. On the repository page, choose **Add file** > **Upload files**.
4. Extract this ZIP on your computer, then drag `README.md`, `sync_fifo.sv`, and `tb_sync_fifo.sv` into the upload area.
5. Choose **Commit changes** to save the files in the repository.

You can also upload this ZIP as a single file, but extracting it first makes the source files and README easier to view directly on GitHub.
