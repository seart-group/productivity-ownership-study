# Process to follow

Before proceeding, you need to make sure of two things:
1. Create the file `apikey.txt` containing the OpenAI API key under the folder `server_setup/proxy_server/`.
2. The user config files for the session group should exist and be properly populated. In particular, each file should contain a unique list of users. For example the following files should exist under the folder `server_setup/main-environment/user-configs/` and contain a list of users (one per line):
    - `users-a-1.txt`
    - `users-a-2.txt`
    - `users-b-1.txt`
    - `users-b-2.txt`
    - `users-c-1.txt`
    - `users-c-2.txt`
    - `users-d-1.txt`
    - `users-d-2.txt`

After these two checks, you can proceed with the deployment of the environment.

NOTE: The following setup assumes that each participant is assigned **two different users, one for the development task and another one for the evolution task**.

From the directory `server_setup`, build and run the container, wait until it finishes, then stop it:

```bash
cd server_setup
docker-compose up --build -d
docker-compose logs -f & logs_pid=$!; while ! docker-compose logs | grep -q "ICSE26 study server up and running!"; do sleep 1; done; pkill -P $logs_pid
docker-compose down
```

At this point, the folder `main-environment/user-data` contains the home directories of the users. Now we can add the tasks for the first and the second sessions, but first we need to update the permissions of the files in the `user-data` folder, in order to make them writable from the host machine:

```bash
cd main-environment
./relax-permissions.sh
```

Now add the tasks of the first and second sessions to the respective user directories (development or evolution). You should do this for all four groups of users (A, B, C and D). For example, for the first session run the following:

```bash
./copy-task.sh development ../../tasks/task1/ user-configs/users-a-1.txt
./copy-task.sh evolution ../../tasks/task1/ user-configs/users-a-2.txt
./copy-task.sh evolution ../../tasks/task1/ user-configs/users-b-1.txt
./copy-task.sh development ../../tasks/task1/ user-configs/users-b-2.txt
./copy-task.sh development ../../tasks/task1/ user-configs/users-c-1.txt
./copy-task.sh evolution ../../tasks/task1/ user-configs/users-c-2.txt
./copy-task.sh evolution ../../tasks/task1/ user-configs/users-d-1.txt
./copy-task.sh development ../../tasks/task1/ user-configs/users-d-2.txt
```

These commands will copy the development and evolution tasks to all users. They will also enable Copilot plugins for groups A and B in the first session, and C and D in the second session, and disable them for groups A and B in the second session, and C and D in the first session.

Start the container, which will also automatically update the permissions for when users log in:

```bash
cd .. # server_setup
docker-compose up --build -d
docker-compose logs -f & logs_pid=$!; while ! docker-compose logs | grep -q "ICSE26 study server up and running!"; do sleep 1; done; pkill -P $logs_pid
```

The container is now ready for both sessions. When all participants finish both sessions, stop the container:

```bash
docker-compose down
```

Remember to update permissions again to make files accessible:

```bash
cd main-environment
./relax-permissions.sh
```

Then, make sure to zip both the `user-data` folder and the `../proxy_server/data` (server logs), provide some representative name and push the files so that we don't lose the data! For example:

```bash
zip -r user-data.zip user-data -i "*/home/development/*" "*/home/evolution/*" "*/home/.appworks/*" "*/home/.vscode-server/data/User/globalStorage/codelounge.tako/*" "*/home/.vscode-server/data/User/globalStorage/n3rds-inc.time/*"
zip -r server-data.zip ../proxy_server/data
mv user-data.zip ../../experiment_results/
mv server-data.zip ../../experiment_results/
git add ../../experiment_results/server-data.zip
git add ../../experiment_results/user-data.zip
git commit -m "add experiment data"
git push
```
