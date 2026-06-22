# RISC-V Pipeline Makefile

# Executables
IVERILOG = iverilog
VVP = vvp

# Directories
RTL_DIR = rtl
TB_DIR = tb
SIM_DIR = sim

# Colors for terminal output
GREEN = \033[0;32m
RED = \033[0;31m
NC = \033[0m # No Color

.PHONY: all clean test_alu test_alu_control test_reg_file test_imm_gen test_inst_mem test_data_mem test_control test_mux test_integration

all: test_alu test_alu_control test_reg_file test_imm_gen test_inst_mem test_data_mem test_control test_mux test_integration

# ----------------------------------------------------
# Module 1: ALU Tests
# ----------------------------------------------------
test_alu: $(SIM_DIR)/alu_test
	@echo "Running ALU tests..."
	@$(VVP) $(SIM_DIR)/alu_test > $(SIM_DIR)/logs/alu_test.log
	@cat $(SIM_DIR)/logs/alu_test.log
	@if grep -q "ALL TESTS PASSED" $(SIM_DIR)/logs/alu_test.log; then \
		echo "$(GREEN)ALU Tests Passed!$(NC)"; \
	else \
		echo "$(RED)ALU Tests Failed! Check $(SIM_DIR)/logs/alu_test.log$(NC)"; \
	fi

$(SIM_DIR)/alu_test: $(TB_DIR)/unit/alu_tb.v $(RTL_DIR)/components/alu.v
	@mkdir -p $(SIM_DIR)/logs $(SIM_DIR)/waves
	@$(IVERILOG) -o $@ $^

# ----------------------------------------------------
# Module 2: ALU Control Tests
# ----------------------------------------------------
test_alu_control: $(SIM_DIR)/alu_control_test
	@echo "Running ALU Control tests..."
	@$(VVP) $(SIM_DIR)/alu_control_test > $(SIM_DIR)/logs/alu_control_test.log
	@cat $(SIM_DIR)/logs/alu_control_test.log
	@if grep -q "ALL TESTS PASSED" $(SIM_DIR)/logs/alu_control_test.log; then \
		echo "$(GREEN)ALU Control Tests Passed!$(NC)"; \
	else \
		echo "$(RED)ALU Control Tests Failed! Check $(SIM_DIR)/logs/alu_control_test.log$(NC)"; \
	fi

$(SIM_DIR)/alu_control_test: $(TB_DIR)/unit/alu_control_tb.v $(RTL_DIR)/components/alu_control.v
	@mkdir -p $(SIM_DIR)/logs $(SIM_DIR)/waves
	@$(IVERILOG) -o $@ $^

# ----------------------------------------------------
# Module 3: Register File Tests
# ----------------------------------------------------
test_reg_file: $(SIM_DIR)/reg_file_test
	@echo "Running Register File tests..."
	@$(VVP) $(SIM_DIR)/reg_file_test > $(SIM_DIR)/logs/reg_file_test.log
	@cat $(SIM_DIR)/logs/reg_file_test.log
	@if grep -q "ALL TESTS PASSED" $(SIM_DIR)/logs/reg_file_test.log; then \
		echo "$(GREEN)Register File Tests Passed!$(NC)"; \
	else \
		echo "$(RED)Register File Tests Failed! Check $(SIM_DIR)/logs/reg_file_test.log$(NC)"; \
	fi

$(SIM_DIR)/reg_file_test: $(TB_DIR)/unit/reg_file_tb.v $(RTL_DIR)/components/reg_file.v
	@mkdir -p $(SIM_DIR)/logs $(SIM_DIR)/waves
	@$(IVERILOG) -o $@ $^

# ----------------------------------------------------
# Module 4: Immediate Generator Tests
# ----------------------------------------------------
test_imm_gen: $(SIM_DIR)/imm_gen_test
	@echo "Running Immediate Generator tests..."
	@$(VVP) $(SIM_DIR)/imm_gen_test > $(SIM_DIR)/logs/imm_gen_test.log
	@cat $(SIM_DIR)/logs/imm_gen_test.log
	@if grep -q "ALL TESTS PASSED" $(SIM_DIR)/logs/imm_gen_test.log; then \
		echo "$(GREEN)Immediate Generator Tests Passed!$(NC)"; \
	else \
		echo "$(RED)Immediate Generator Tests Failed! Check $(SIM_DIR)/logs/imm_gen_test.log$(NC)"; \
	fi

$(SIM_DIR)/imm_gen_test: $(TB_DIR)/unit/imm_gen_tb.v $(RTL_DIR)/components/imm_gen.v
	@mkdir -p $(SIM_DIR)/logs $(SIM_DIR)/waves
	@$(IVERILOG) -o $@ $^

# ----------------------------------------------------
# Module 5: Instruction Memory Tests
# ----------------------------------------------------
test_inst_mem: $(SIM_DIR)/inst_mem_test
	@echo "Running Instruction Memory tests..."
	@$(VVP) $(SIM_DIR)/inst_mem_test > $(SIM_DIR)/logs/inst_mem_test.log
	@cat $(SIM_DIR)/logs/inst_mem_test.log
	@if grep -q "ALL TESTS PASSED" $(SIM_DIR)/logs/inst_mem_test.log; then \
		echo "$(GREEN)Instruction Memory Tests Passed!$(NC)"; \
	else \
		echo "$(RED)Instruction Memory Tests Failed! Check $(SIM_DIR)/logs/inst_mem_test.log$(NC)"; \
	fi

$(SIM_DIR)/inst_mem_test: $(TB_DIR)/unit/inst_mem_tb.v $(RTL_DIR)/components/inst_mem.v
	@mkdir -p $(SIM_DIR)/logs $(SIM_DIR)/waves
	@$(IVERILOG) -o $@ $^

# ----------------------------------------------------
# Module 6: Data Memory Tests
# ----------------------------------------------------
test_data_mem: $(SIM_DIR)/data_mem_test
	@echo "Running Data Memory tests..."
	@$(VVP) $(SIM_DIR)/data_mem_test > $(SIM_DIR)/logs/data_mem_test.log
	@cat $(SIM_DIR)/logs/data_mem_test.log
	@if grep -q "ALL TESTS PASSED" $(SIM_DIR)/logs/data_mem_test.log; then \
		echo "$(GREEN)Data Memory Tests Passed!$(NC)"; \
	else \
		echo "$(RED)Data Memory Tests Failed! Check $(SIM_DIR)/logs/data_mem_test.log$(NC)"; \
	fi

$(SIM_DIR)/data_mem_test: $(TB_DIR)/unit/data_mem_tb.v $(RTL_DIR)/components/data_mem.v
	@mkdir -p $(SIM_DIR)/logs $(SIM_DIR)/waves
	@$(IVERILOG) -o $@ $^

# ----------------------------------------------------
# Module 7: Control Unit Tests
# ----------------------------------------------------
test_control: $(SIM_DIR)/control_test
	@echo "Running Control Unit tests..."
	@$(VVP) $(SIM_DIR)/control_test > $(SIM_DIR)/logs/control_test.log
	@cat $(SIM_DIR)/logs/control_test.log
	@if grep -q "ALL TESTS PASSED" $(SIM_DIR)/logs/control_test.log; then \
		echo "$(GREEN)Control Unit Tests Passed!$(NC)"; \
	else \
		echo "$(RED)Control Unit Tests Failed! Check $(SIM_DIR)/logs/control_test.log$(NC)"; \
	fi

$(SIM_DIR)/control_test: $(TB_DIR)/unit/control_tb.v $(RTL_DIR)/components/control.v
	@mkdir -p $(SIM_DIR)/logs $(SIM_DIR)/waves
	@$(IVERILOG) -o $@ $^

# ----------------------------------------------------
# Module 8: Multiplexer Tests
# ----------------------------------------------------
test_mux: $(SIM_DIR)/mux_test
	@echo "Running Mux tests..."
	@$(VVP) $(SIM_DIR)/mux_test > $(SIM_DIR)/logs/mux_test.log
	@cat $(SIM_DIR)/logs/mux_test.log
	@if grep -q "ALL TESTS PASSED" $(SIM_DIR)/logs/mux_test.log; then \
		echo "$(GREEN)Mux Tests Passed!$(NC)"; \
	else \
		echo "$(RED)Mux Tests Failed! Check $(SIM_DIR)/logs/mux_test.log$(NC)"; \
	fi

$(SIM_DIR)/mux_test: $(TB_DIR)/unit/mux_tb.v $(RTL_DIR)/components/mux2_32.v $(RTL_DIR)/components/mux3_32.v
	@mkdir -p $(SIM_DIR)/logs $(SIM_DIR)/waves
	@$(IVERILOG) -o $@ $^

# ----------------------------------------------------
# Integration Tests (Phase 2)
# ----------------------------------------------------
test_integration: $(SIM_DIR)/integration_test
	@echo "Running Integration tests..."
	@$(VVP) $(SIM_DIR)/integration_test > $(SIM_DIR)/logs/integration_test.log
	@cat $(SIM_DIR)/logs/integration_test.log

$(SIM_DIR)/integration_test: $(TB_DIR)/integration/tb_pipeline.v $(RTL_DIR)/core/riscv_pipeline.v $(RTL_DIR)/components/*.v $(RTL_DIR)/pipeline/*.v
	@mkdir -p $(SIM_DIR)/logs $(SIM_DIR)/waves
	@$(IVERILOG) -o $@ $^

# ----------------------------------------------------
# Validation Tests (Phase 2.5)
# ----------------------------------------------------
VALIDATE_TESTS = arith memory branch_taken branch_not_taken jal dependency mixed load_use

$(SIM_DIR)/tb_validation: $(TB_DIR)/integration/tb_validation.v $(RTL_DIR)/core/riscv_pipeline.v $(RTL_DIR)/components/*.v $(RTL_DIR)/pipeline/*.v
	@mkdir -p $(SIM_DIR)/validate
	@$(IVERILOG) -o $@ $^

validate: $(SIM_DIR)/tb_validation
	@echo "=================================="
	@echo "RV32I VALIDATION SUITE"
	@echo "=================================="
	@for test in $(VALIDATE_TESTS); do \
		$(VVP) $< +TEST_NAME=$$test +INIT_FILE="programs/tests/$$test.hex" | grep -q "PASS" && echo "PASS: $$test" || echo "FAIL: $$test"; \
	done
	@echo "=================================="
	@echo "ALL TESTS EXECUTED"
	@echo "=================================="

# ----------------------------------------------------
# Clean
# ----------------------------------------------------
clean:
	@echo "Cleaning simulation files..."
	@rm -f $(SIM_DIR)/*_test
	@rm -f $(SIM_DIR)/logs/*.log
	@rm -f $(SIM_DIR)/waves/*.vcd
	@echo "Clean complete."
