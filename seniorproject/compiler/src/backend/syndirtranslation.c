/** Syntax Directed Translation Implementation File
 *  ========================================================================
 *
 *  The syntax directed translation of the declarations and staments of the 
 *		parse tree convert the parse tree into an intermediate representation
 *		more easily converted into assembly code or further iterations
 *		of IR code.
 *
 *
 *  Last Modified: 4/29/14
 *  Contributor(s): Nicholas Otto
 */
#include "syndirtranslation.h"

#define copy_type(A,B) A->type.keyword = B->type.keyword; \
	A->type.identifier = B->type.identifier; \
	A->type.op = B->type.op; \
	A->type.constant = B->type.constant; \
	A->type.begin = B->type.begin; \
	A->type.cast = B->type.cast; \
	A->type.goto_op = B->type.goto_op;

int synthesize_attributes(struct tree_node *head){

	int check = 0;
	if (head == NULL){
		return 0;
	}
	printf("Synthesizing Attributes\n");//DEBUG

	struct tree_node *curr = head->first_child;
	while (curr != NULL){
		if (curr->node_type == DECLARATION){
			check = synthesize_declaration(curr);
		}
		else if (curr->node_type == STATEMENT){
			check = synthesize_statement(curr);
		}
		else{
			printf("Error synthesizing parse tree attributes! At compound statement\n");//DEBUG
			return -1;
		}
		if (check <= 0){
			printf("Error Synthesizing Attributes!\n");
			return -1;
		}
		curr = curr->right_sibling;
	}

	return 0;
}

int synthesize_declaration(struct tree_node *node){
	printf("At Synthesize_Declaration!\n");//DEBUG
	int check = 0;

	struct tree_node *specifiers = node->first_child;

	//declarations must have specifiers and typdef_name subnodes
	if (specifiers == NULL || specifiers->right_sibling == NULL){
		printf("Incorrectly formatted declaration!\n");
		return -1;
	}
	struct tree_node *typdef_name = specifiers->right_sibling;
	check = synthesize_declaration_specifiers(specifiers) | 
				synthesize_typedef_name(typdef_name);
	if (check <= 0){
		printf("Error synthesizing declaration!\n");
		return -1;
	}

	struct identifier *d = malloc(sizeof(struct identifier));

	copy_type(d , typdef_name->attributes.op);

	d->lexeme = typdef_name->attributes.op->lexeme;
	d->offset = typdef_name->attributes.b;

	if (specifiers->attributes.a != NULL){
		d->pointer = 1;
	} else { d->pointer = 0;}
	d->type_specifier = specifiers->attributes.eq->type_specifier;
	d->type_qualifier = NOTIMPLEMENTED;

	
	printf("Synthesizing Declaration!\n");//DEBUG

	node->attributes.x = d;

	print_declaration(node);

	return 1;
}

int synthesize_declaration_specifiers(struct tree_node *node){
	printf("At Synthesize_Declaration_Specifiers!\n");//DEBUG

	struct tree_node *curr = node->first_child;
	while (curr != NULL){
		if (curr->node_type == TYPE_QUALIFIER){
			node->attributes.x = curr->attributes.x;
		}
		else if (curr->node_type == TYPE_SPECIFIER){
			node->attributes.eq = curr->attributes.eq;
		}

		curr = curr->right_sibling;
	}

	
	return 1;
}

int synthesize_typedef_name(struct tree_node *node){
	printf("At Synthesize_Typdef_Name!\n");//DEBUG

	//simply push define array attributes up a level.
	if (node->first_child != NULL){
		node->attributes.b = node->first_child->attributes.b;
		node->attributes.b->offset_length = strtoul(node->attributes.b->lexeme, NULL, 0);
	}
	else{
		node->attributes.b = NULL;
	}

	return 1;
}

int synthesize_statement(struct tree_node *snode){
	printf("Synthesizing Statement!\n");//DEBUG
	return -1;
}

int synthesize_expression_statement(struct tree_node *esnode){return -1;}

int synthesize_expression(struct tree_node *enode){return -1;}

int synthesize_assignment_expression(struct tree_node *aenode){return -1;}

int synthesize_lvalue(struct tree_node *lvnode){return -1;}

int synthesize_lpostfix_expression(struct tree_node *lpnode){return -1;}

int synthesize_primary_expression_mods(struct tree_node *pemnode){return -1;}

int synthesize_assignment_operator(struct tree_node *aonode){return -1;}

int synthesize_rvalue(struct tree_node *rvnode){return -1;}

int synthesize_cast_expression(struct tree_node *cenode){return -1;}

int synthesize_lrvalue(struct tree_node *lrvnode){return -1;}

int synthesize_reference_operator(struct tree_node *renode){return -1;}

int synthesize_postfix_expression(struct tree_node *penode){return -1;}

int synthesize_binary_op(struct tree_node *bonode){return -1;}

int synthesize_jump_statement(struct tree_node *jsnode){return -1;}

int synthesize_labeled_statement(struct tree_node *lsnode){return -1;}

void print_declaration(struct tree_node *d){
	printf("Declaration Information\n");
	printf("\tType: %d\n", d->attributes.x->type_specifier);
	printf("\tPointer: %d\n", d->attributes.x->pointer);
	printf("\tName: %s\n", d->attributes.x->lexeme);
	printf("\tArray Length: %d\n", d->attributes.x->offset == NULL ? 0 : d->attributes.x->offset->offset_length );
}
