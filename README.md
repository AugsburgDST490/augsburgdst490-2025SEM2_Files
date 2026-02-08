# Repository for DST 490
**Semester: Spring 2026**

- Files are organized by the day that they occur in the [course calendar](https://docs.google.com/document/d/1IkLp4tm9vqroM48c2gDwmllNh6jdlmhbe72HFHFL3UE/edit?tab=t.0).

- **To track changes in the upstream repo**, use the following command in the terminal (one time only):
```
git remote add upstream https://github.com/AugsburgDST490/augsburgdst490-2025SEM2_Files.git
```

- **To check** use the following command in the terminal:
```
git remote -v  # You should see `origin` (your fork) and `upstream` (the class repo).
```

- **To update your fork with any changes:** Do this before beginning new work and whenever they want any updates. **Save all local files.**  Then run the following:

```
git stash  # This safely stores staged / unstaged changes
git checkout main  # It may already say you are on main
git fetch upstream  # Ddownloads newest commits without automatically merging them into your code.
git rebase upstream/main # Starts to merge
git stash pop  # Brings your work back
```

- **Merge conflicts:** You *may* get a merge conflict in the rebase if I've updated a file that you are working on. You will need to edit them accordingly:

```
<<<<<<< Updated upstream
(instructor code)
=======
(your stashed edits)
>>>>>>> Stashed changes
```

Then once you've made the changes:

```
git add <file>
git rebase --continue   # only needed if rebase was still in progress
```

