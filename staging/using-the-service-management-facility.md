# Using the Serice Management Facility

The Service Management Facility (SMF) is the SmartOS way to start and
stop services (web, database, email, and so on) and provides two
distinct advantages:

- It monitors services and restarts them automatically if they
    stop running.
- It understands the dependencies between services. For example, SMF
    will not attempt to start your webserver if your network is down.

A great resource for SMF is Ben Rockwood's [SMF CheatSheet](http://www.cuddletech.com/blog/pivot/entry.php?id=182).
