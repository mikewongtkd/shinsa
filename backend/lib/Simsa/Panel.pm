package Simsa::Panel;
use base qw( Simsa::Group );

# ============================================================
sub examine {
# ============================================================
	my $self  = shift;
	my $group = shift;
	my $class = $group->class();

	return unless $class eq 'Group';

	$self->{ group } = $group;
}

1;
