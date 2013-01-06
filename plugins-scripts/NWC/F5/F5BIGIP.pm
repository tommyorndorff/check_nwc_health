package NWC::F5::F5BIGIP;

use strict;

use constant { OK => 0, WARNING => 1, CRITICAL => 2, UNKNOWN => 3 };

our @ISA = qw(NWC::F5);

sub init {
  my $self = shift;
  $self->{components} = {
      powersupply_subsystem => undef,
      fan_subsystem => undef,
      temperature_subsystem => undef,
      cpu_subsystem => undef,
      memory_subsystem => undef,
      disk_subsystem => undef,
      environmental_subsystem => undef,
      ltm_subsystem => undef,
  };
  # gets 11.* and 9.*
  $self->{productversion} = $self->get_snmp_object('F5-BIGIP-SYSTEM-MIB', 'sysProductVersion');
  if (! $self->check_messages()) {
    if ($self->mode =~ /device::hardware::health/) {
      $self->analyze_environmental_subsystem();
      #$self->auto_blacklist();
      $self->check_environmental_subsystem();
    } elsif ($self->mode =~ /device::hardware::load/) {
      $self->analyze_cpu_subsystem();
      #$self->auto_blacklist();
      $self->check_cpu_subsystem();
    } elsif ($self->mode =~ /device::hardware::memory/) {
      $self->analyze_mem_subsystem();
      #$self->auto_blacklist();
      $self->check_mem_subsystem();
    } elsif ($self->mode =~ /device::interfaces/) {
      $self->analyze_interface_subsystem();
      $self->check_interface_subsystem();
    } elsif ($self->mode =~ /device::lb/) {
      $self->analyze_ltm_subsystem();
      $self->check_ltm_subsystem();
    } elsif ($self->mode =~ /device::shinken::interface/) {
      $self->analyze_interface_subsystem();
      $self->shinken_interface_subsystem();
    }
  }
}

sub analyze_environmental_subsystem {
  my $self = shift;
  $self->{components}->{environmental_subsystem} =
      NWC::F5::F5BIGIP::Component::EnvironmentalSubsystem->new();
}

sub analyze_interface_subsystem {
  my $self = shift;
  $self->{components}->{interface_subsystem} =
      NWC::IFMIB::Component::InterfaceSubsystem->new();
}

sub analyze_cpu_subsystem {
  my $self = shift;
  $self->{components}->{cpu_subsystem} =
      NWC::F5::F5BIGIP::Component::CpuSubsystem->new();
}

sub analyze_mem_subsystem {
  my $self = shift;
  $self->{components}->{mem_subsystem} =
      NWC::F5::F5BIGIP::Component::MemSubsystem->new();
}

sub analyze_ltm_subsystem {
  my $self = shift;
  $self->{components}->{ltm_subsystem} =
      NWC::F5::F5BIGIP::Component::LTMSubsystem->new();
}

sub check_environmental_subsystem {
  my $self = shift;
  $self->{components}->{environmental_subsystem}->check();
  $self->{components}->{environmental_subsystem}->dump()
      if $self->opts->verbose >= 2;
}

sub check_interface_subsystem {
  my $self = shift;
  $self->{components}->{interface_subsystem}->check();
  $self->{components}->{interface_subsystem}->dump()
      if $self->opts->verbose >= 2;
}

sub check_cpu_subsystem {
  my $self = shift;
  $self->{components}->{cpu_subsystem}->check();
  $self->{components}->{cpu_subsystem}->dump()
      if $self->opts->verbose >= 2;
}

sub check_mem_subsystem {
  my $self = shift;
  $self->{components}->{mem_subsystem}->check();
  $self->{components}->{mem_subsystem}->dump()
      if $self->opts->verbose >= 2;
}

sub check_ltm_subsystem {
  my $self = shift;
  $self->{components}->{ltm_subsystem}->check();
  $self->{components}->{ltm_subsystem}->dump()
      if $self->opts->verbose >= 2;
}

