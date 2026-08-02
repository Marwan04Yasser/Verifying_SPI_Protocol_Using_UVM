# Verifying-SPI-Protocol-Using-UVM# SPI Slave & Single-Port RAM Verification — with SPI Wrapper Integration

UVM-based functional verification project covering an **SPI Slave**, a **Single-Port RAM**, and a **SPI Wrapper** that integrates the two into a single, verified sub-system. Each part has its own self-checking UVM testbench with constrained-random stimulus, a reference (golden) model, SystemVerilog assertions, and functional/code/assertion coverage.

**Authors:** Mahmoud Alsayed Kebeisy & Marwan Yasser Rifaat
**Language / Methodology:** SystemVerilog, UVM
**Simulator:** QuestaSim

---

## Project Structure

The verification effort is split into three parts, each with its own UVM environment:

```
Part 1 - SPI Slave
Part 2 - Single-Port RAM
Part 3 - SPI Wrapper (SPI Slave + Single-Port RAM integration)
```

---

## Part 1 — SPI Slave

Verifies an SPI Slave design for correct serial-to-parallel data handling.

**UVM Environment**
- `env` — top-level environment
- `agent` — active agent containing driver, monitor, sequencer
- `driver` — drives stimulus onto the SPI interface
- `monitor` — samples interface activity and reconstructs transactions
- `sequencer` / `seq_item` — sequence item and sequencer
- `sequences` — main sequence, reset sequence
- `config` (`cfg`) — environment/agent configuration object
- `collector` — coverage collector
- `scoreboard` — compares DUT output against the golden/reference model
- `interface` — SPI DUT interface
- `shared_pkg` — shared types/parameters used across the environment
- `test` — top-level UVM test
- `top` — top-level testbench module
- SVA — protocol/data-integrity assertions bound to the DUT

**RTL**
- Design (DUT) RTL code
- Golden model used as the verification reference

**Verification Plan**
A structured plan mapping design requirements → stimulus generation → functional coverage → checks (assertions/scoreboard), covering protocol correctness and data-storage behavior.

**Results**
- Assertion table with all bound SVA properties
- Code coverage (statement / branch / condition / toggle)
- Functional coverage (coverpoints & cross coverage)
- Assertion coverage
- Bug log documenting issues found and fixed during verification

**Run**
```tcl
do run.do
```
(see the part's `.do` file for the exact `vlib` / `vlog` / `vsim` sequence)

---

## Part 2 — Single-Port RAM

Verifies a Single-Port RAM design for correct read/write behavior under randomized access patterns.

**UVM Environment**
- `env`, `agent`, `driver`, `monitor`, `sequencer`, `seq_item`
- `cfg` — configuration object
- `collector` — coverage collector
- `scoreboard` — reference-model comparison
- `interface` — RAM DUT interface
- `top`, `src` — top-level module and source file list
- SVA — assertions on RAM read/write behavior

**Sequences**
- `rst_seq` — reset sequence
- `read_only_sequence`
- `write_only_sequence`
- `read_write_sequence`

**RTL**
- Design (DUT) RTL code
- Golden model used as the verification reference

**Verification Plan**
Covers reset behavior, isolated read/write operations, and simultaneous read/write access, mapped to stimulus generation, functional coverage, and checks.

**Results**
- Code coverage, functional coverage, assertion coverage
- Bug log documenting issues found and fixed during verification

**Run**
```tcl
do run.do
```

---

## Part 3 — SPI Wrapper (Integration)

Wraps the SPI Slave and Single-Port RAM together and verifies the integrated design end-to-end.

**UVM Environment**
- `agent`, `driver`, `monitor`, `sequencer`, `seq_item`
- Golden model for the combined SPI + RAM datapath
- SVA — end-to-end protocol/data assertions

**RTL**
- Design (DUT) RTL code — SPI Wrapper integrating the SPI Slave and RAM
- Golden model used as the verification reference

**Verification Plan**
Validates that data written through the SPI interface is correctly stored in and retrieved from RAM, exercising the combined design with constrained-random SPI transactions.

---

## Verification Methodology

- **Stimulus:** Constrained-random sequences per part (reset, read-only, write-only, read-write, main sequence)
- **Checking:** Self-checking scoreboards comparing DUT outputs against golden/reference models
- **Assertions:** SystemVerilog Assertions (SVA) bound to each DUT for protocol and data-integrity checks
- **Coverage:** Functional coverage (coverpoints and cross coverage), code coverage (statement, branch, condition, toggle), and assertion coverage, tracked to closure for each part
- **Debug:** Bugs found during simulation are logged with root cause and fix, and re-verified via targeted assertions/coverage

## Tools

- SystemVerilog / UVM
- QuestaSim (simulation, coverage, and waveform analysis)

## Notes

This README summarizes the verification report contained in the project document (architecture diagrams, verification plans, RTL/testbench source, coverage reports, and bug logs for all three parts). Replace the `do run.do` placeholders above with the actual `.do` file names once the source tree is added to this repository.
# Verifying_SPI_Protocol_Using_UVM
