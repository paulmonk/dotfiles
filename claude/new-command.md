# .claude/new-command

This command helps you create effective, structured command files for your `.claude` folder by applying proven prompt engineering techniques specifically tailored to the codebase's needs.

## Usage

```bash
claude < .claude/new-command
```

## Interactive Process

When you run this command, I will:

1. Ask you to describe the task or problem you want to create a command for
2. Rephrase your requirements to confirm my understanding
3. Ask specific clarifying questions about:
   - The command's primary purpose and success criteria
   - Technical domain knowledge needed (Ethereum, React, etc.)
   - Required inputs and expected outputs
   - Common failure modes or edge cases
4. Suggest ways to structure the command for maximum effectiveness
5. Create a well-structured command file based on your feedback
6. Help you evaluate if the command meets your needs

This interactive approach ensures your command will solve actual problems you face when working in the codebase.

## Prompt Design Framework

### 1. PURPOSE DEFINITION

Every command should clearly answer:
- What specific problem does this command solve in the codebase?
- Why is this task challenging or time-consuming to do manually?
- What technical domain knowledge is required (Ethereum, TypeScript, React, etc.)?
- How will this command be used in your workflow?

### 2. CLEAR COMMUNICATION

Write commands as if you're speaking to a knowledgeable colleague who's new to this specific task:
- Define any codebase-specific terminology or concepts
- Provide complete technical context without assuming deep knowledge
- Be explicit about what you want the output to include and exclude
- Include concrete examples from your codebase that demonstrate success

### 3. STRUCTURED FORMAT

Use this consistent structure for all commands:
- Title with clear naming convention (action-object pattern)
- Purpose statement with specific codebase-context relevance
- Interactive process section that prompts for necessary inputs
- Step-by-step process description with technical details
- Output format with clear expectations
- Codebase-specific examples showing real use cases
- Evaluation criteria tied to project standards

### 4. TECHNICAL DEPTH

Effective commands include:
- References to specific project architecture patterns
- Links to similar implementations in the codebase
- Awareness of coding standards and best practices
- Consideration of TypeScript type safety
- Proper error handling approaches

### 5. ITERATIVE IMPROVEMENT

Commands should be treated as living documents:
- Test the command on various real-world tasks
- Note where Claude misunderstands or produces incorrect outputs
- Update your command to address identified issues
- Add examples for edge cases specific to your codebase
- Refine based on team feedback and changing project needs

## Command Template

```markdown
# .claude/{action}-{object}

This command helps you {primary function} for {specific context} in the codebase, following established patterns and best practices.

## Usage

```bash
claude < .claude/{action}-{object}
```

## Interactive Process

When you run this command, I will:
1. Ask you to describe your specific needs for {object}
2. Confirm understanding by rephrasing your requirements
3. Ask clarifying questions about:
   - {domain-specific consideration 1}
   - {domain-specific consideration 2}
   - {domain-specific consideration 3}
4. Identify potential edge cases specific to the codebase's architecture

## Input Requirements

Before running this command, prepare:
1. {specific input 1 with example}
2. {specific input 2 with example}
3. {specific input 3 with example}

## Process

I'll help you {accomplish task} by:

1. {Step 1 with technical details}
2. {Step 2 with technical details}
3. {Step 3 with technical details}
4. {Step 4 with technical details}
5. {Step 5 with technical details}

## Technical Implementation Guide

### {Implementation Section 1}

```typescript
// Example code showing implementation pattern
```

### {Implementation Section 2}

```typescript
// Example code showing implementation pattern
```

## Output Format

I'll provide:
1. {Output component 1}
2. {Output component 2}
3. {Output component 3}

## Examples

### Example 1: {Concrete example from codebase}

{Detailed walkthrough with code snippets}

### Example 2: {Another concrete example}

{Detailed walkthrough with code snippets}

## Evaluation Criteria

A successful {object} should:
1. {Specific technical criterion 1}
2. {Specific technical criterion 2}
3. {Specific technical criterion 3}
4. {Specific technical criterion 4}
5. {Specific technical criterion 5}

## Related Resources

- Similar implementations in the codebase: {file paths}
- Documentation: {links}
- Tests to reference: {file paths}


## Best Practices for Codebase-Specific Commands

1. **Code Context Awareness**
   - Reference existing patterns in the codebase
   - Maintain consistent naming conventions with project standards
   - Consider the structure and package relationships

2. **Technical Precision**
   - Always include typing
   - Follow doc comment style from CLAUDE.md
   - Reference error handling patterns

3. **Interactive Refinement**
   - Begin by restating the user's request in technical terms
   - Ask about specific technical requirements before generating code
   - Verify understanding of technical concepts where relevant
   - Use examples from the codebase to clarify intent

4. **Evaluation Integration**
   - Include specific references to project linting rules
   - Remind users to run appropriate tests
   - Suggest ways to validate the solution works in context

Remember that the best commands balance technical precision with clarity, provide concrete examples, and actively guide the user through thinking about edge cases particular to the codebase.
