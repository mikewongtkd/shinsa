package Shinsa::RequestManager;
use Shinsa;
use Data::Dumper;

# ============================================================
sub new {
# ============================================================
	my ($class) = map { ref || $_ } shift;
	my $table   = _class( $class );
	my $self    = bless {}, $class;
	return $self;
}

# ============================================================
sub get {
# ============================================================
	my $self = shift;
	my $uuid = shift;
	my $item = Shinsa::DBO::_get( $uuid );
	return $item;
}

# ============================================================
sub handle {
# ============================================================

}

# ============================================================
sub save {
# ============================================================

}

1;
