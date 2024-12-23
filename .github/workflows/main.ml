name: Deluge No Seed Torrent Download and Upload Artifacts

on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  download-and-upload:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v2

    - name: Set up Deluge
      run: |
        sudo apt update
        sudo apt install -y deluge

    - name: Configure Deluge to not seed
      run: |
        # Disable seeding behavior (Auto Manage)
        deluge-console "config --set stop_on_seed True"
        deluge-console "config --set share_ratio 0.0"  # No sharing

    - name: Download Torrent via Magnet Link with Deluge
      run: |
        mkdir -p ~/downloads
        magnet_link="magnet:?xt=urn:btih:62850A9765A30822792790F5743BF13CEC9BD12E&dn=Abbott+and+Costello+Meet+the+Killer%2C+Boris+Karloff++%28Comedy+1949%29++720p++BrRip&tr=udp%3A%2F%2Ftracker.leechers-paradise.org%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.coppersurfer.tk%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.pirateparty.gr%3A6969%2Fannounce&tr=udp%3A%2F%2Fexodus.desync.com%3A6969%2Fannounce&tr=udp%3A%2F%2Fopentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fexplodie.org%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.pomf.se%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80%2Fannounce&tr=udp%3A%2F%2F9.rarbg.com%3A2710%2Fannounce&tr=udp%3A%2F%2F9.rarbg.to%3A2710%2Fannounce&tr=udp%3A%2F%2F9.rarbg.me%3A2710%2Fannounce&tr=udp%3A%2F%2Fopen.demonii.si%3A1337%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=http%3A%2F%2Ftracker.openbittorrent.com%3A80%2Fannounce&tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.internetwarriors.net%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.leechers-paradise.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fcoppersurfer.tk%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.zer0day.to%3A1337%2Fannounce"  # Replace with your magnet link
        download_folder="~/downloads"
        
        # Add the magnet link to Deluge and start the download
        deluge-console "add $magnet_link" "start" "exit"

        # Wait for the download to complete (adjust time based on the file size)
        sleep 60  # Adjust as needed based on download progress.

    - name: Push Artifacts
      uses: actions/upload-artifact@v3
      with:
        name: downloaded-files
        path: ~/downloads
