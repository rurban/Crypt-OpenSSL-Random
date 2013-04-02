use Config;
$self->{LIBS} = ['-lssleay32 -llibeay32'] if $Config{cc} =~ /cl/;
$self->{LIBS} = ['-lssl32 -leay32']       if $Config{cc} =~ /gcc/;
