# setup gel_scram

create superuser role gel_scram {
    set password := 'gel_scram_password'
};

configure instance insert Auth {
    user := 'gel_scram',
    method := (insert SCRAM),
    priority := 2
};


# setup gel_scram

create superuser role gel_trust;

configure instance insert Auth {
    user := 'gel_trust',
    method := (insert Trust),
    priority := 3
};
