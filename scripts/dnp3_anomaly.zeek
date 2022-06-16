redef record DNP3::Info += {
    ## Indicate if the originator of the connection is part of the
    ## "private" address space defined in RFC1918.
    anomaly: int &default=1 &log;
};

