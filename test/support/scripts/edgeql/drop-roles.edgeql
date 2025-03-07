# reset gel_scram

drop role gel_scram;

configure INSTANCE
reset Auth
filter Auth.user = 'gel_scram';


# reset gel_trust

drop role gel_trust;

configure INSTANCE
reset Auth
filter Auth.user = 'gel_trust';
