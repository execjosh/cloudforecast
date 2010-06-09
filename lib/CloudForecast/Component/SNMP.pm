package CloudForecast::Component::SNMP;

use CloudForecast::Component -connector;
use SNMP;

sub session {
    my $self = shift;
    $self->{session} ||= SNMP::Session->new(
        DestHost => $self->address,
        Community => $self->config->{community},
        Version => $self->config->{version},
        Timeout => 1000000,
    );
    $self->{session};
}

sub get {
    my $self = shift;
    my @ret = $self->session->get( SNMP::VarList->new(@_) );
    return \@ret;
}

sub get_by_int {
    my $self = shift;
    my $ret = $self->get(@_);
    return [ map { $_ =~ /^[0-9\.]+$/ ? $_ : '' } @$ret ];
}


1;

