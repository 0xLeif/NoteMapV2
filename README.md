## NoteMap v2

NoteMap is built to be simple and intuitive. There are 2 main components of a Note Map: notes, and clusters

The NoteMap itself is a large sized UIScrollView with a grey background.

Notes are a preset sized UITextView that changes background color. The keyboard of the UITextView is a UIScrollView. This allows the user to scroll the view and edit the note's color. There will be a trash button to delete the note. Double Tap Gesture to add a new note of the current color selected in the Color Picker (Color Picker not added yet)

Clusters are used to group notes. Clusters have an array of notes, and a background color (possibly a title in the future). If a note is created, it is either: added to a cluster within range of the same color as the note and resize the cluster, or a new cluster is created with only the new note, and the new note's color. Currently notes are moveable, but cluster movability will be later.

The clusters should be dynamic in two ways: it should automatically 'consume' new notes of the same color, within a range from the current radius, and two clusters of the same color within a range should merge.


### Currently working:
* Adding notes
* Editing note text
* Moving notes
* Cluster creation based on notes
* Dynamic clusters

