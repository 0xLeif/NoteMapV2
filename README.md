## NoteMap v2

NoteMap is built to be simple and intuitive. There are 3 main components of a Note Map: notes, clusters, and the map itself

The NoteMap itself is a large sized UIScrollView with a grey background.

Notes are a preset sized UITextView that changes background color. The keyboard of the UITextView is a UIScrollView. This allows the user to scroll the view and edit the note's color. Double Tap Gesture to add a new note of the current color selected in the Global Color Picker (top left). Two finger double tap to delete a note.

Clusters are used to group notes. Clusters have an array of notes, and a background color (a title in the future). If a note is created, it is either: added to a cluster within range of the same color as the note and resize the cluster, or a new cluster is created with only the new note, and the new note's color.

The clusters is dynamic in two ways: it  automatically 'consumes' new notes of the same color, within a range from the current radius, and two clusters of the same color within a range merge.


### Currently working:
* Adding/ Removing notes
* Editing note text
* Moving notes
* Cluster creation based on notes
* Dynamic clusters (resizable and moveable)
* Saving and Loading Notemaps
* Analytics (notes added, distance moved)

### Beta Release
Signup- https://docs.google.com/forms/d/e/1FAIpQLSeLlf6vfMLjdYwbCHzxIN-ljn9WqLcKEgufSpGl5mm7zpqi4w/viewform

