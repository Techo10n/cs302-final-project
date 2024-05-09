-- =================================Queries===================================
-- TESTING DELETE TRIGGER
-- deleting user with public playlist
DELETE FROM User WHERE UserID = 1;
-- deleting user with private playlist
DELETE FROM User WHERE UserID = 3;
-- selecting playlists to check if they were deleted
SELECT * FROM Playlist WHERE PlaylistID = 1; -- should return all columns but UserID should equal NULL
SELECT * FROM Playlist WHERE PlaylistID = 3; -- should return no columns

-- RESETTING TABLES AFTER TESTING
-- deleting playlists to reset table
DELETE FROM Playlist WHERE PlaylistID = 1;
DELETE FROM Playlist WHERE PlaylistID = 3;
-- reinserting users after deletion
INSERT INTO User VALUES
	(1, 'user123', 'user123@example.com', 'password123', '1990-05-15', 'USA'),
    (3, 'artfanatic', 'artfanatic@yahoo.com', 'art456', '1995-12-10', 'Canada');
-- reinserting playlists after deletion/modification
INSERT INTO Playlist VALUES
    (1, 'Favorites', 1, 'Collection of top...', '2023-07-01', 5, 1200, TRUE),
    (3, 'Study Sessions', 3, 'Music for focusing...', '2024-03-15', 10, 2000, FALSE);

-- TESTING STORED PROCEDURES
-- testing GetPlaylistSongs
CALL GetPlaylistSongs(5, @song_title);
SELECT @song_title;
-- testing GetSongArtist
CALL GetSongArtist(2, @artist_name);
SELECT @artist_name;
-- testing GetArtistSongs
CALL GetArtistSongs(3, @song_title);
SELECT @song_title;
-- testing GetSongGenre
CALL GetSongGenre(19, @song_genre);
SELECT @song_genre;
-- testing FindArtistGenre
CALL FindArtistGenre(1, @artist_genre);
SELECT @artist_genre;
-- testing GetSongDurationMinutes
CALL GetSongDurationMinutes(44, @song_duration_minutes);
SELECT @song_duration_minutes;
-- testing GetSongViews
CALL GetSongViews(23, @song_views);
SELECT @song_views;
-- testing GetArtistViews
CALL GetArtistViews(4, @artist_total_views);
SELECT @artist_total_views;
-- testing GetTopArtist
CALL GetTopArtist(@artist_name);
SELECT @artist_name;
-- testing GetTopArtistByGenre
CALL GetTopArtistByGenre('Pop', @artist_name);
SELECT @artist_name;
-- testing FindLatestCommentsByGenre
CALL FindLatestCommentsByGenre('Rock', @comment_id);
SELECT @comment_id;