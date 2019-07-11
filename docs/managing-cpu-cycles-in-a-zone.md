# Managing CPU Cycles in a Zone

CPU usage in a zone is primarily managed through three different
properties.

- **CPU cap:** The maximum number of CPU cycles that are allocated to
  a zone. Zones can never consume more CPU cycles than what is
  allocated to the cap.
- **CPU shares:** The minimum number of CPU cycles available to a zone
  at any given time. SmartOS uses the Fair Share Scheduler (FSS) to
  distribute CPU shares among zones.
- **CPU baseline:** A soft limit on the number of CPU cycles a hosted
  application can consume. If an application experiences heavy
  throughput, it can use CPU bursting to temporarily consume CPU
  cycles that exceed the allocated baseline limit, providing a
  temporary performance boost.

- [CPU Caps and Shares](cpu-caps-and-shares.md)
- [CPU Bursting](cpu-bursting.md)
