.text			// Code section

.global main		// Expose to assembler
main:
	b main		// Branch to the same instruction
