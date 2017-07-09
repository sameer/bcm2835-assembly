.text			// Code section

.global main		// Expose to assembler
main:
	sub pc, pc, #8	// Push program counter back so program basically restarts
