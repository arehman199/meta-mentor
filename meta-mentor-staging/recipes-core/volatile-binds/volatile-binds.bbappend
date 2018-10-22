# mount /etc/systemd with rw rights.
VOLATILE_BINDS_append = "\
    ${USER_DATA_MOUNT}/systemd ${sysconfdir}/systemd\n\
"
