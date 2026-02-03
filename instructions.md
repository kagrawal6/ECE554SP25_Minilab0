# Minilab0 - Complete Lab Instructions

## Lab Overview

**Objectives:**
- Design simple digital logic in Verilog and simulate it in QuestaSim
- Use Quartus to program the DE1-SoC board
- Use IPs from the Quartus IP Catalog
- Understand resource utilization report from Quartus synthesis tool

**Lab Structure:**
- Part 1: Design your custom logic in Verilog/SystemVerilog
- Part 2: Use IP blocks from Quartus IP Catalog for the same logic

**Peripherals Used:**
- 7-Segment Display
- LEDs
- Buttons (Key 0 is used as active low reset)

---

## Step 1: Create a Project Using System Builder

The DE1-SoC evaluation board provides a software called "System Builder" that generates all the project files with correct device and pin information.

1. Download the Altera DE1-SoC SystemCD from the course website under Minilab0
2. Open `DE1-SoC_v.5.1.1_HWrevF_SystemCD\Tools\SystemBuilder\DE1SoC_SystemBuilder.exe`
3. In the System Builder window:
   - Set **Project Name** to `Minilab0`
   - Select the following peripherals:
     - CLOCK
     - Button x4
     - LED x10
     - 7-Segment x6
   - Set **GPIO-0 Header** to "None"
4. Click **Generate** and save as `Minilab0.qpf`
5. The generated files will be placed under the `CodeGenerated/DE1-SoC` folder under SystemBuilder

---

## Step 2: Understanding the Generated Files

The System Builder creates the following files:

| File | Description |
|------|-------------|
| `Minilab0.qpf` | Quartus project file |
| `Minilab0.qsf` | Quartus setting file, including device, pin assignments, etc. |
| `Minilab0.sdc` | Synopsys design constraint file used for compiling the design |
| `Minilab0.v` | Top level Verilog HDL template file |

**Note:** The use of System Builder is very handy as it ensures the pin mappings in the .qsf file are correct. In most cases you may wish to edit the generated .qsf file to use more "standard" signal names.

---

## Step 3: Add Sources to the Project

Normally you would copy the generated files to your work area and edit both the .qsf and the top-level .v file to define your desired signal names.

However, for this lab, you will use the provided files (from the zip file) which have been edited to have more meaningful signal names for some ports.

1. Download `Minilab0.zip` from the course website
2. In the lab zip file, we have provided the top-level .v, a couple of .sv files and other Quartus project-related files for you
3. Copy all the files to the **Minilab0** folder under `CodeGenerated/Minilab0` folder created by the system builder software
4. **Important:** Make sure to also copy the .qsf file from the .zip and overwrite the generated .qsf file

---

## Step 4: Open the Project in Quartus

1. From the **Minilab0** folder, double-click `Minilab0.qpf` to open the project in Quartus
2. Go to **Project > Add/Remove Files in Project...**
3. Add all the source files into your project:
   - `Minilab0.v`
   - `fifo.sv`
   - `mac.sv`
4. Click **Apply** then **OK**

**Reference:** The .qsf file has the top-level pin assignments for the peripherals used in this lab. Check tables 3-5 to 3-9 in `DE1-SoC_v.5.1.1_HWrevF_SystemCD/UserManual/DE1-SoC_User_manual.pdf` for pin information. If you need to modify any future project by adding more peripherals, you can add signals to your top-level Verilog file for that peripheral and directly assign the pins in the .qsf file according to tables in the above-mentioned pdf.

---

## Step 5: What to Code (Part 1 - Custom Verilog)

For this lab, you will be writing the code for the FIFO and multiply-accumulate (MAC) units in Verilog/SystemVerilog.

**Files to implement:**
- `fifo.sv` - FIFO module
- `mac.sv` - Multiply-Accumulate module

**Purpose:** The logic performs a dot product of two arrays. The result of the dot product is stored in an output register that is displayed in **hex** format on the **7-segment display** when the switch **SW0** is turned **ON**. **LED1** should also turn **ON** indicating that the logic is in **DONE** state.

**Simulation:** Write a testbench and simulate your code in QuestaSim.

---

## Step 6: Compile Code and Program the FPGA

### Compile the Design

1. After completing the coding, compile the project in Quartus
2. Go to **Processing > Start Compilation** (or press Ctrl+L)
3. Observe the progress of the compilation steps from the bottom-left Tasks panel
4. Full compilation may take some time to go through the place & route stage

### Locate the Output File

After successful compilation, you will find the generated `Minilab0.sof` file under your project folder in the `output_files` directory. This file contains the bitstream to download into the FPGA to program it.

### Program the Board

1. From the DE1-SoC files, locate the following file:
   `DE1-SoC_v.5.1.1_HWrevF_SystemCD\UserManual\My_First_Fpga.pdf`
2. **Carefully follow Chapter 4.2** to download the .sof file into the FPGA

**Summary of programming steps from Chapter 4.2:**
1. Connect the DE1-SoC board to your PC via USB-Blaster II cable
2. Connect power supply and turn the board ON
3. In Quartus, go to **Tools > Programmer**
4. Click **Hardware Setup** and select **USB-Blaster II**
5. Click **Add File** and navigate to `output_files\Minilab0.sof`
6. Check the **Program/Configure** checkbox
7. Click **Start** to program the FPGA

---

## Step 7: Sample Demo (Expected Result)

When working correctly:
- The 7-segment display should show `000578` (or similar hex value representing the dot product)
- LED1 should be ON indicating DONE state
- SW0 must be ON to display the result

---

## Step 8: Use Quartus IP Catalog (Part 2)

Quartus provides a catalog of different IPs that can be configured and used instead of custom Verilog code. The purpose of these IPs is to provide users generic building blocks to reduce coding effort for designing systems.

### Access the IP Catalog

1. In Quartus, go to **Tools > IP Catalog**
2. Search for the IPs you need

### IPs to Use

For this lab, you will be replacing the FIFO and MAC units that you wrote in Verilog with:
- **FIFO** - replaces your custom FIFO
- **LPM_MULT** - multiplier IP
- **LPM_ADD_SUB** - adder IP (for accumulation)

Note: Although there exists a Multiply-Accumulate IP, unfortunately Quartus Prime Lite Edition does not provide it.

### Configure Each IP

1. Search for an IP in the catalog and double-click it
2. A separate window will pop up for each IP. Name the IP and click **OK**
3. A **MegaWizard Plug-In Manager** window will pop up
4. Configure the IP according to the requirements of the design for this lab
5. Consult the documentation for each IP to do so (click the **Documentation** button in the IP configuration pop-up window)
6. **For FIFO:** Select separate clocks for reads and writes during configuration, but use the same clock when you make the signal connections
7. Configure the IP by clicking **Next** and selecting the options for that IP
8. Click **Finish** and **Yes** to add the IP files to your current project

**Important:** Reading documentation is a necessary skill for any Engineering job and will be useful if you want to succeed in this course.

### Locate the IP Interface

1. Go to the **Project Navigator** window and select **Files** from the drop-down menu
2. You should see a `.qip` file under Files
3. Open the `.v` file under the `.qip` file - this file has the interface to your IP which you can use to instantiate the IP block in your code

### Modify Top-Level Code

You will have to change the top-level code to support the IPs (instantiate the IP modules instead of your custom modules).

---

## Step 9: Simulate with IP Libraries

### Compile the Design

```
vlog Minilab0.v fifo.sv mac.sv testbench_tb.sv
```

### Run Simulation with IP Libraries

The following paths are to the IP libraries that you will be using for this lab:
- `C:/intelFPGA_lite/23.1std/questa_fse/intel/verilog/220model`
- `C:/intelFPGA_lite/23.1std/questa_fse/intel/verilog/altera_mf`

(For those who are interested, all these paths are specified in the `modelsim.ini` file.)

To run the simulation in QuestaSim, type this command:

```
vsim -L C:/intelFPGA_lite/23.1std/questa_fse/intel/verilog/altera_mf -L C:/intelFPGA_lite/23.1std/questa_fse/intel/verilog/220model -vopt work.testbench_tb -voptargs=+acc
```

### Program the Board

Program the board following the steps discussed in Step 6.

---

## Step 10: Export Resource Usage Reports

1. Click on **View Report** from the drop-down menu of **Analysis and Synthesis** from the Tasks window
2. A window with the title **Compilation Report** should appear inside the Quartus window
3. Right-click on the **Resource Usage Summary** inside the **Analysis and Synthesis** folder inside that window
4. Export the file

**Export twice:**
- Save as `Minilab0_Resource_Usage_Summary1.rpt` for the first half (without IP)
- Save as `Minilab0_Resource_Usage_Summary2.rpt` for the second half (with IP)

Submit these files too. (1 submission per team)

---

## Step 11: Submission

### Files to Submit

1. Submit the `.v` and `.sv` files to the dropbox for Minilab0 on Canvas (1 submission per team)
2. Submit both resource usage reports:
   - `Minilab0_Resource_Usage_Summary1.rpt`
   - `Minilab0_Resource_Usage_Summary2.rpt`
3. Create a **zipped file** with all the submission files and name it as:
   `Minilab0_<member1 netid>_<member2 netid>.zip`

### GitHub Repository

1. Create a repository with the name `ECE554SP25_Minilab0` on GitHub
2. Upload all `.v` and `.sv` files to your individual GitHub accounts
3. If you don't have a GitHub account yet, please create one and become familiar with Git commands

### Demo

You must demo your working designs (with and without IPs) to the instructor (George) or the TA (Abhishek) by the end of lab period on 01/28 to avoid any penalty. Demos should be done in teams. See Grading for more details.

### Report

The report should be submitted individually and should have:
- Your GitHub repository info
- Details about how you created the repository and added the files
- Your simulation log
- A snapshot of the waveform from QuestaSim
- Discussion about the differences in resource utilization between the two submitted resource usage reports

---

## Quick Reference

| Action | How To |
|--------|--------|
| Open Project | Double-click `Minilab0.qpf` or File > Open Project (Ctrl+J) |
| Add Files | Project > Add/Remove Files in Project |
| Compile | Processing > Start Compilation (Ctrl+L) |
| IP Catalog | Tools > IP Catalog |
| Programmer | Tools > Programmer |
| View Reports | Tasks panel > Analysis and Synthesis > View Report |
