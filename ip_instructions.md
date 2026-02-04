# Part 2: Using Quartus IP Catalog - Detailed Instructions

## Overview

For Part 2 of the lab, you need to replace your custom `fifo.sv` and `mac.sv` with Quartus IP blocks:

| Custom Module | Replaced By |
|---------------|-------------|
| `fifo.sv` (FIFO) | **FIFO IP** |
| `mac.sv` (multiply) | **LPM_MULT IP** |
| `mac.sv` (accumulate) | **LPM_ADD_SUB IP** |

---

## Step 1: Open IP Catalog

1. In Quartus, go to **Tools > IP Catalog**
2. The IP Catalog window will open on the right side of the screen

---

## Step 2: Add FIFO IP

### 2.1 Search for FIFO
1. In the IP Catalog search box, type **"FIFO"**
2. Look for **"FIFO"** under **Library > Basic Functions > On Chip Memory > FIFO**
3. Double-click on **FIFO**

### 2.2 Name the IP
1. A dialog box appears asking for the file name
2. Enter: **`fifo_ip`**
3. Choose your project directory as the save location
4. Click **OK**

### 2.3 Configure FIFO in MegaWizard

The MegaWizard Plug-In Manager opens. Configure as follows:

**Page 1 - Basic Settings:**

| Setting | Value |
|---------|-------|
| How wide should the FIFO be? | **8** bits |
| How deep should the FIFO be? | **8** words |
| Clock configuration | **Dual clock: use separate 'rdclk' and 'wrclk' clocks** |

**Important Note:** The lab slides say "Select separate clocks for reads and writes during configuration but use the same clock when you make the signal connections." This means:
- Configure with dual clocks in the wizard
- When instantiating, connect both `rdclk` and `wrclk` to `CLOCK_50`

**Page 2 - Optional Signals:**

| Setting | Enable? |
|---------|---------|
| usedw (used words count) | No (optional) |
| empty | **Yes** (required) |
| full | **Yes** (required) |
| almost_empty | No |
| almost_full | No |

**Page 3 - Read/Write Clock:**
- Keep defaults

**Page 4 - Summary:**
1. Review your settings
2. Click **Finish**
3. When prompted "Do you want to add this IP to the project?", click **Yes**

---

## Step 3: Add LPM_MULT IP (Multiplier)

### 3.1 Search for LPM_MULT
1. In IP Catalog, search for **"LPM_MULT"**
2. Find it under **Library > Basic Functions > Arithmetic > LPM_MULT**
3. Double-click on **LPM_MULT**

### 3.2 Name the IP
1. Enter: **`mult_ip`**
2. Click **OK**

### 3.3 Configure Multiplier in MegaWizard

**Page 1 - General:**

| Setting | Value |
|---------|-------|
| How wide is dataa? | **8** bits |
| How wide is datab? | **8** bits |
| Signed or unsigned? | **Unsigned** |
| Output width | **16** bits (8 + 8 = 16) |

**Page 2 - Pipeline:**

| Setting | Value |
|---------|-------|
| Use pipeline? | **No** (combinational multiply) |

**Page 3 - Summary:**
1. Review settings
2. Click **Finish**
3. Click **Yes** to add to project

---

## Step 4: Add LPM_ADD_SUB IP (Adder)

### 4.1 Search for LPM_ADD_SUB
1. In IP Catalog, search for **"LPM_ADD_SUB"**
2. Find it under **Library > Basic Functions > Arithmetic > LPM_ADD_SUB**
3. Double-click on **LPM_ADD_SUB**

### 4.2 Name the IP
1. Enter: **`adder_ip`**
2. Click **OK**

### 4.3 Configure Adder in MegaWizard

**Page 1 - General:**

| Setting | Value |
|---------|-------|
| How wide is dataa? | **24** bits |
| How wide is datab? | **24** bits |
| Operation | **Addition only** |

Note: The accumulator is 24 bits (DATA_WIDTH * 3 = 8 * 3 = 24). The 16-bit product from the multiplier needs to be zero-extended to 24 bits when connecting.

**Page 2 - Pipeline:**

| Setting | Value |
|---------|-------|
| Use pipeline? | **No** (combinational add) |

**Page 3 - Summary:**
1. Review settings
2. Click **Finish**
3. Click **Yes** to add to project

---

## Step 5: View Generated IP Files

After adding all IPs:

1. In the **Project Navigator** panel (left side of Quartus)
2. Select **Files** from the dropdown menu
3. You should see `.qip` files for each IP:
   - `fifo_ip.qip`
   - `mult_ip.qip`
   - `adder_ip.qip`
4. Expand each `.qip` file to see the generated `.v` file
5. **Open the `.v` file** to see the module interface (port names and widths)

This is important because you need to know the exact port names to instantiate the IPs in your code.

---

## Step 6: Modify Top-Level to Use IPs

You need to modify your design to replace the custom modules with IP instantiations.

### 6.1 Check Generated Port Names

Open each generated `.v` file and note the port names. They are typically:

**FIFO IP (fifo_ip.v):**
```
module fifo_ip (
    wrclk,      // Write clock
    rdclk,      // Read clock  
    wrreq,      // Write request (write enable)
    rdreq,      // Read request (read enable)
    data,       // Input data [7:0]
    q,          // Output data [7:0]
    wrfull,     // Write side full flag
    rdempty     // Read side empty flag
);
```

**LPM_MULT IP (mult_ip.v):**
```
module mult_ip (
    dataa,      // Input A [7:0]
    datab,      // Input B [7:0]
    result      // Product [15:0]
);
```

**LPM_ADD_SUB IP (adder_ip.v):**
```
module adder_ip (
    dataa,      // Input A [23:0]
    datab,      // Input B [23:0]
    result      // Sum [23:0]
);
```

### 6.2 Example: Modified Top-Level Instantiation

Replace your custom FIFO and MAC instantiations with IP instantiations:

```verilog
// ============================================
// FIFO IP Instantiation (2 instances)
// ============================================

// FIFO for Array 1
fifo_ip fifo_inst_0 (
    .wrclk(CLOCK_50),       // Use same clock for both
    .rdclk(CLOCK_50),       // Use same clock for both
    .wrreq(wren[0]),        // Write enable
    .rdreq(rden[0]),        // Read enable
    .data(datain[0]),       // Input data
    .q(dataout[0]),         // Output data
    .wrfull(full[0]),       // Full flag
    .rdempty(empty[0])      // Empty flag
);

// FIFO for Array 2
fifo_ip fifo_inst_1 (
    .wrclk(CLOCK_50),
    .rdclk(CLOCK_50),
    .wrreq(wren[1]),
    .rdreq(rden[1]),
    .data(datain[1]),
    .q(dataout[1]),
    .wrfull(full[1]),
    .rdempty(empty[1])
);

// ============================================
// Multiplier IP Instantiation
// ============================================

wire [15:0] product;

mult_ip multiplier (
    .dataa(dataout[0]),     // 8-bit from FIFO 0
    .datab(dataout[1]),     // 8-bit from FIFO 1
    .result(product)        // 16-bit product
);

// ============================================
// Adder IP for Accumulation
// ============================================

reg [23:0] accumulator;
wire [23:0] accumulator_next;

adder_ip adder (
    .dataa(accumulator),                    // Current accumulator value
    .datab({{8{1'b0}}, product}),           // Zero-extend 16-bit product to 24-bit
    .result(accumulator_next)               // New accumulator value
);

// Accumulator register
always @(posedge CLOCK_50 or negedge rst_n) begin
    if (~rst_n) begin
        accumulator <= 24'd0;
    end
    else if (state == EXEC) begin
        accumulator <= accumulator_next;
    end
end

// Output
assign macout = accumulator;
```

### 6.3 Key Changes from Custom Code

| Custom Code | IP-Based Code |
|-------------|---------------|
| `FIFO` module | `fifo_ip` module |
| `MAC` module with internal multiply | Separate `mult_ip` and `adder_ip` |
| `Ain * Bin` in MAC | `mult_ip` does multiplication |
| `accumulator + product` in MAC | `adder_ip` does addition |

---

## Step 7: Compile the Design

1. Go to **Processing > Start Compilation** (or press Ctrl+L)
2. Wait for compilation to complete
3. Check for errors in the Messages panel
4. Verify the `.sof` file is generated in `output_files/`

---

## Step 8: Simulate with IP Libraries in QuestaSim

When simulating designs that use Quartus IPs, you need to include the IP libraries.

### 8.1 IP Library Paths

The following paths contain the IP simulation models:
- `C:/intelFPGA_lite/23.1std/questa_fse/intel/verilog/220model`
- `C:/intelFPGA_lite/23.1std/questa_fse/intel/verilog/altera_mf`

### 8.2 Compile Your Design

```
vlog Minilab0.v fifo_ip.v mult_ip.v adder_ip.v testbench_tb.sv
```

### 8.3 Run Simulation with Libraries

```
vsim -L C:/intelFPGA_lite/23.1std/questa_fse/intel/verilog/altera_mf -L C:/intelFPGA_lite/23.1std/questa_fse/intel/verilog/220model -vopt work.testbench_tb -voptargs=+acc
```

### 8.4 In QuestaSim GUI

```
add wave -r /*
run -all
```

---

## Step 9: Program the Board

1. Connect DE1-SoC board via USB-Blaster II
2. Go to **Tools > Programmer**
3. Add `output_files/Minilab0.sof`
4. Click **Start**
5. Test on board:
   - Press KEY[0] to reset
   - Flip SW[0] to display result
   - Verify 7-segment shows `001B58`
   - Verify LED[1] is ON

---

## Step 10: Export Resource Usage Report

1. In the **Tasks** panel, expand **Analysis and Synthesis**
2. Right-click on **Resource Usage Summary**
3. Select **View Report**
4. In the Compilation Report window, right-click on **Resource Usage Summary**
5. Select **Export**
6. Save as **`Minilab0_Resource_Usage_Summary2.rpt`**

---

## IP Port Reference

### FIFO IP Ports

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `wrclk` | input | 1 | Write clock |
| `rdclk` | input | 1 | Read clock |
| `wrreq` | input | 1 | Write request (enable) |
| `rdreq` | input | 1 | Read request (enable) |
| `data` | input | 8 | Data to write |
| `q` | output | 8 | Data read out |
| `wrfull` | output | 1 | FIFO full (write side) |
| `rdempty` | output | 1 | FIFO empty (read side) |

### LPM_MULT IP Ports

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `dataa` | input | 8 | First operand |
| `datab` | input | 8 | Second operand |
| `result` | output | 16 | Product (dataa * datab) |

### LPM_ADD_SUB IP Ports

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `dataa` | input | 24 | First operand |
| `datab` | input | 24 | Second operand |
| `result` | output | 24 | Sum (dataa + datab) |

---

## Troubleshooting

### "Cannot find module" error in simulation
- Make sure you include the IP library paths with `-L` flags in vsim command

### FIFO not working correctly
- Verify both `wrclk` and `rdclk` are connected to `CLOCK_50`
- Check that `wrfull` maps to your `full` signal and `rdempty` maps to `empty`

### Multiplier output width mismatch
- Ensure you configured 8-bit inputs and 16-bit output
- Zero-extend product to 24 bits before adding: `{{8{1'b0}}, product}`

### IP files not found
- After adding IP, click **Yes** when asked to add to project
- Check Project Navigator > Files to verify `.qip` files are listed

---

## Comparison: Custom vs IP Implementation

After completing both parts, your report should discuss the differences in resource utilization:

| Metric | Custom (Part 1) | IP-Based (Part 2) |
|--------|-----------------|-------------------|
| ALMs | Check report | Check report |
| Registers | Check report | Check report |
| Memory Bits | Check report | Check report |
| DSP Blocks | Likely 0 | May use DSP for multiplier |

The IP-based design may use dedicated DSP blocks for multiplication, which can be more efficient than using general logic cells.
