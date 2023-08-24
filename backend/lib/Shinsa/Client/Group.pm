package Shinsa::Client::Group;
use lib qw( /usr/local/freescore/lib );
use Mojolicious::Controller;
use Digest::SHA1 qw( sha1_hex );
use JSON::XS;

# ============================================================
sub new {
# ============================================================
	my ($class) = map { ref || $_ } shift;
	my $self = bless {}, $class;
	$self->init( @_ );
	return $self;
}

# ============================================================
sub init {
# ============================================================
	my $self       = shift;
	my $websocket  = shift;
	my $exam       = $websocket->param( 'exam' );
	my $panel      = $websocket->param( 'panel' );

	$self->{ gid }    = "$exam-$panel";
	$self->{ client } = {};
}

# ============================================================
sub add {
# ============================================================
	my $self   = shift;
	my $client = shift;
	my $cid    = $client->id();
	$self->{ client }{ $cid } = $client;
}

# ============================================================
sub changed {
# ============================================================
	my $self    = shift;
	my $json    = new JSON::XS();

	my $status  = sha1_hex( $json->canonical->encode( $self->status()));
	my $changed = $status ne $self->{ status };
	$self->{ status } = $status;

	return $changed;
}

# ============================================================
sub clients {
# ============================================================
	my $self    = shift;
	my $filter  = shift;
	my @clients = sort { $a->role() cmp $b->role() || $a->cid() cmp $b->cid() } values %{ $self->{ client }};

	if( $filter ) {
		@clients = grep { $_->role() =~ /^$filter/ } @clients;
	}

	return @clients;
}

# ============================================================
sub judges {
# ============================================================
	my $self    = shift;
	my @clients = grep { $_->role() =~ /^judge/i } sort { $a->role() cmp $b->role() || $a->cid() cmp $b->cid() } values %{ $self->{ client }};

	return @clients;
}

# ============================================================
sub id {
# ============================================================
	my $self = shift;
	return $self->{ id };
}

# ============================================================
sub remove {
# ============================================================
	my $self   = shift;
	my $client = shift;
	my $cid    = undef;

	$cid = ref $client ? $client->id() : $client;
	delete $self->{ client }{ $cid };
}

# ============================================================
sub status {
# ============================================================
	my $self = shift;
	return [ map { $_->status() } $self->clients() ];
}

1;
