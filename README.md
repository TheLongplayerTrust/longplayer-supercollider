# longplayer-supercollider

[_Longplayer_](https://longplayer.org) is a thousand year long musical composition by Jem Finer.

For more information about _Longplayer_, read an [overview of the piece](https://longplayer.org/about/overview/).

Due to its duration it was written to be performed by any available and compatible technology. It is not exclusively a piece of electronic / digital music. It can and has been performed by [people](https://longplayer.org/listen/longplayer-live/) using a graphic score and no elecricity, by a computer, by 12 modified turntables etc . . . a version for a choir is in development.

This is an implementation of the _Longplayer_ algorithm in SuperCollider, which can be run on any compatible computer with audio output.

For more information about _Longplayer_'s algorithm, see the Longplayer Trust README file.

## Requirements

- SuperCollider 3.5 +

- A Linux or macOS system with audio output

- The _Longplayer_ audio file ([20-20.aif](https://longplayer.org/audio/20-20.aif))

## Usage 

- copy the audio file, 20-20.aif, into the same directory as the code.
- set the variable timeZoneOffset in line 51: its value should be set to your computer clock's deviation from the time at the International Date Line, e.g. +12 in London.
- you will hear nothing initially on startup while the code waits for the next two minute period to begin.
