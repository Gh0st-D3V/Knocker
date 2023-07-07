###########################################################################
# Gathering Online User Usernames and Server Entries (GOOSE)              #
# Author: gh0st                                                           #
# Creation Date: 1/26/2023                                                #
# Version: 3.6                                                            #
# About: Takes a .cvs file of first and last names and generates 2        #
# username possibilites, First intial Lastname and Firstname Last initial #
###########################################################################

import ftplib
import csv
a = input("Enter Server List: ")
# Open the file containing the list of FTP servers
with open( a, "r") as servers_file:
    servers = servers_file.readlines()
    # Strip newlines from the server names
    servers = [server.strip() for server in servers]
    # Create a list to store the staff lists
    staff_lists = []
    for server in servers:
        try:
            ftp = ftplib.FTP(server)
            ftp.login('anonymous','')
            
            with open("StaffList.csv", "wb") as local_file:
                ftp.retrbinary("RETR StaffList.csv", local_file.write)
            ftp.quit()
            with open("StaffList.csv", "r") as local_file:
                staff_lists.append(list(csv.reader(local_file)))
        except ftplib.all_errors as e:
            print(e)
            continue
    #flatten the list
    staff_lists = [item for sublist in staff_lists for item in sublist]
    # Create a list to store the usernames
    usernames = []
    # Create a set to store the used usernames
    used_usernames = set()
    for row in staff_lists:
        if not row:
            continue
        if row[0] != "FirstName": #skip the header row
            first_name = row[0]
            last_name = row[1]
            # Generate the possible usernames
            username1 = first_name[0] + last_name
            username2 = first_name + last_name[0]
            if not (username1 in used_usernames or username2 in used_usernames):
                # Add the usernames to the list and the set
                usernames.append([username1, username2])
                used_usernames.add(username1)
                used_usernames.add(username2)
    with open("Usernames.csv", "w") as output_file:
        writer = csv.writer(output_file)
        # Write the usernames
        for username in usernames:
            writer.writerow(username)
