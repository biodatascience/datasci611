### Feedback system v1.0

1. Student A gives feedback to Student B in the form of a text file with a specific file name format: `to_studentB_from_studentA_proj1.txt`
2. Here, `studentA` is the github ID for that student
3. `proj1` should also be standardized to make the TA's lives a little bit simpler
4. The students send their feedback file to the TA via a private Git Classroom repository.
5. The TA runs a script to assign a random number to anonymize student A's ID
6. The TA sends the anonymized feedback to student B via the private Git Classroom repository.
7. Student B writes a new file in a simlar format: `to_12345_from_studentB_proj1.txt`
8. Student B includes any written feedback they want to give to student A (who they only know by the random ID) and a score line `Score:5` where the score rubric is standardized for everyone.
9. The TA de-codes Student A's ID using a script which updates the file names and extracts the scores.
10. The TA sends the feedback evaluation to Student A via private Git Classroom repository.