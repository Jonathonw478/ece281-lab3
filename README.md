# Lab 3: Thunderbird Turn Signal

VHDL for ECE 281 [Lab 3](https://usafa-ece.github.io/ece281-book/lab/lab3.html)

Targeted toward Digilent Basys3. Make sure to install the [board files](https://github.com/Xilinx/XilinxBoardStore/tree/2018.2/boards/Digilent/basys3).

Tested on Windows 11.

---

## Build the project

You can simply open `thunderbird.xpr` and Vivado will do the rest!

## GitHub Actions Testbench

The workflow uses the [setup-ghdl-ci](https://github.com/ghdl/setup-ghdl-ci) GitHub action
to run a *nightly* build of [GHDL](https://ghdl.github.io/ghdl/).

The workflow uses GHDL to analyze, elaborate, and run the entity specified in the `.github/workflows/testbench.yml`.

```yaml
env:
  TESTBENCH_ENTITY: myfile
```
![Waveform from thunderbird_fsm_tb]

[(<img width="776" alt="SimulationScreenShot" src="https://github.com/Jonathonw478/ece281-lab3/assets/142036146/c53bf6db-2551-4925-a426-6cbc4d17b68c">](https://usafa0-my.sharepoint.com/:i:/g/personal/c26jonathon_watson_afacademy_af_edu/EWED7NafZL5EgeK7HYcKyzABPaFwygAplhB3porY7i58ew?e=CpX0ul)

<img width="776" alt="SimulationScreenShot" src="https://github.com/Jonathonw478/ece281-lab3/assets/142036146/c489b69b-e2b4-4050-b098-4d980f542be6">


If successful then GHDL will quietly exit with a `0` code.
If any of the `assert` statements fail **with** `severity error` then GHDL will cease the simulation and exit with non-zero code; this will also cause the workflow to fail.

## Documentation
No help received.
