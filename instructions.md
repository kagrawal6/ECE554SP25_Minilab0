# Minilab0 - Quartus Setup and FPGA Programming Instructions

## Part 1: Project Setup (Already Done)

Since you already have `Minilab0.qpf`, `Minilab0.qsf`, `Minilab0.sdc`, and `Minilab0.v` from the provided zip file, you can skip the System Builder step. But for reference:

**If you ever need to create a new project:**
1. Run `DE1-SoC_v.5.1.1_HWrevF_SystemCD\Tools\SystemBuilder\DE1SoC_SystemBuilder.exe`
2. Set Project Name: `Minilab0`
3. Select: CLOCK, Button x4, LED x10, 7-Segment x6
4. Set GPIO-0 Header to "None"
5. Click "Generate" - saves to `CodeGenerated/DE1-SoC/`

---

## Part 2: Open Project in Quartus

### Step 1: Launch Quartus
- Open Quartus Prime Lite Edition (typically installed at `C:\intelFPGA_lite\23.1std\quartus\bin64\quartus.exe`)

### Step 2: Open the Project
1. Go to **File > Open Project** (or press Ctrl+J)
2. Navigate to your project folder
3. Select `Minilab0.qpf` and click **Open**

---

## Part 3: Add Source Files to Project

### Step 1: Add Files
1. Go to **Project > Add/Remove Files in Project...**
2. In the dialog, click the "..." button next to "File name"
3. Navigate to your project folder and add these files:
   - `Minilab0.v` (if not already added)
   - `fifo.sv`
   - `mac.sv`
4. Click **Add** for each file
5. Click **Apply** then **OK**

### Step 2: Verify Files Added
1. In the **Project Navigator** panel (left side), select **Files** from the dropdown
2. You should see:
   - `Minilab0.v`
   - `fifo.sv`
   - `mac.sv`
   - `Minilab0.sdc`

---

## Part 4: Compile the Design

### Step 1: Start Compilation
1. Go to **Processing > Start Compilation** (or press Ctrl+L)
2. Or click the blue "Play" button in the toolbar

### Step 2: Monitor Progress
Watch the **Tasks** panel (bottom-left) for progress:
- Analysis & Synthesis
- Fitter (Place & Route)
- Assembler
- Timing Analysis

This takes 2-5 minutes depending on your computer.

### Step 3: Check for Errors
- If there are errors, they will appear in the **Messages** panel at the bottom
- Warnings are usually OK, but errors must be fixed

### Step 4: Verify Output
After successful compilation, you will have:
```
output_files\Minilab0.sof
```
This is the bitstream file for the FPGA.

---

## Part 5: Export Resource Usage Report (For Submission)

1. In the **Tasks** panel, expand **Analysis & Synthesis**
2. Right-click on **Resource Usage Summary**
3. Select **View Report**
4. In the **Compilation Report** window, find **Analysis & Synthesis > Resource Usage Summary**
5. Right-click on it > **Export** > Save as `Minilab0_Resource_Usage_Summary1.rpt`

---

## Part 6: Program the FPGA Board

### Step 1: Connect the Board
1. Connect the DE1-SoC board to your PC via the **USB-Blaster II** cable (the USB port near "USB-Blaster II" label on the board)
2. Connect the **power supply** and turn the board **ON** (red power switch)

### Step 2: Open the Programmer
1. Go to **Tools > Programmer**
2. If no hardware is detected, click **Hardware Setup...**
3. Select **USB-Blaster II** from the dropdown and click **Close**

### Step 3: Add the SOF File
1. Click **Add File...**
2. Navigate to `output_files\Minilab0.sof`
3. Select it and click **Open**
4. Make sure the **Program/Configure** checkbox is checked

### Step 4: Program the Board
1. Click **Start**
2. Progress bar should reach 100%
3. You should see "Successful" in the status

---

## Part 7: Test on the Board

1. Press **KEY[0]** (rightmost button) to reset the design
2. Wait a moment for the state machine to complete (almost instant at 50MHz)
3. Flip **SW[0] UP** (rightmost switch) to display the result
4. Expected display: `001B58` on the 7-segment displays
5. **LED[1] should be ON** (indicates DONE state, since state = 2 = binary 10)

---

## Quick Reference

| Action | Shortcut/Menu |
|--------|---------------|
| Open Project | Ctrl+J |
| Add Files | Project > Add/Remove Files |
| Compile | Ctrl+L or Processing > Start Compilation |
| Programmer | Tools > Programmer |
| View Reports | Processing > Compilation Report |

---

## Simulation in QuestaSim

### Compile the Design
```
vlog Minilab0.v fifo.sv mac.sv testbench_tb.sv
```

### Run Simulation
```
vsim work.testbench_tb -voptargs=+acc
```

### In QuestaSim GUI
```
add wave -r /*
run -all
```

### Using IP Libraries (Part 2 of Lab)
```
vsim -L C:/intelFPGA_lite/23.1std/questa_fse/intel/verilog/altera_mf -L C:/intelFPGA_lite/23.1std/questa_fse/intel/verilog/220model -vopt work.testbench_tb -voptargs=+acc
```

---

## Submission Checklist

- [ ] Submit `.v` and `.sv` files to Canvas dropbox (1 per team)
- [ ] Export `Minilab0_Resource_Usage_Summary1.rpt` (Part 1 - custom Verilog)
- [ ] Export `Minilab0_Resource_Usage_Summary2.rpt` (Part 2 - with IP blocks)
- [ ] Create zip file: `Minilab0_<member1 netid>_<member2 netid>.zip`
- [ ] Create GitHub repo: `ECE554SP25_Minilab0`
- [ ] Upload all `.v` and `.sv` files to GitHub
- [ ] Demo both designs (with and without IPs) to instructor/TA by end of lab

### Report Should Include
- GitHub repository info
- Details about how you created the repository and added files
- Simulation log
- Snapshot of waveform from QuestaSim
- Discussion of differences in resource utilization between the two reports
