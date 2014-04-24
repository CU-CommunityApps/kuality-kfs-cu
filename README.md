Installation
============

### For developers:

1) Install the [kuality-kfs](https://github.com/CU-CommunityApps/kuality-kfs) gem.

2) Find the installation location of your kuality-kfs gem and replace the *lib* folder
   with a symlink to the *lib* folder for your kuality-kfs project directory.
   **You only need to do this if you do not want to reinstall the gem every time
   you make a change in the kuality-kfs project**

3) Setup the kuality-kfs-cu GitHub project in your IDE as you would any other Ruby project.

4) Create any necessary run configurations (or your IDE's equivalent).
   You will need to include the following things:
..* **Environment Variables:** ANSICON-;JRUBY-OPTS=-X+O
..* **Working directory:** The kuality-kfs-cu project base directory

You may want to set up your run configurations to use the Cucumber profiles included
in the project. They can be found in [./cucumber.yml](./cucumber.yml)
