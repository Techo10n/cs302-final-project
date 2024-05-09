-- Project Title: LemOn; Author: Zechariah Frierson

-- drop procedures for ease of testing
DROP PROCEDURE IF EXISTS GetPlaylistSongs;
DROP PROCEDURE IF EXISTS GetSongArtist;
DROP PROCEDURE IF EXISTS GetArtistSongs;
DROP PROCEDURE IF EXISTS GetSongGenre;
DROP PROCEDURE IF EXISTS FindArtistGenre;
DROP PROCEDURE IF EXISTS GetSongDurationMinutes;
DROP PROCEDURE IF EXISTS GetSongViews;
DROP PROCEDURE IF EXISTS GetArtistViews;
DROP PROCEDURE IF EXISTS GetTopArtist;
DROP PROCEDURE IF EXISTS GetTopArtistByGenre;
DROP PROCEDURE IF EXISTS FindLatestCommentsByGenre;

-- define all procedures
DELIMITER //
CREATE PROCEDURE GetPlaylistSongs(IN playlist_id INT UNSIGNED, OUT song_title VARCHAR(100))
    BEGIN
        SELECT Song.Title INTO song_title
        FROM Song
        JOIN Playlist_Song ON Song.SongID = Playlist_Song.SongID
        WHERE Playlist_Song.PlaylistID = playlist_id;
    END//

CREATE PROCEDURE GetSongArtist(IN song_id INT UNSIGNED, OUT artist_name VARCHAR(100))
    BEGIN
        SELECT Artist.ArtistName INTO artist_name
        FROM Artist
        JOIN Song_Artist ON Artist.ArtistID = Song_Artist.ArtistID
        WHERE Song_Artist.SongID = song_id;
    END;
    //

CREATE PROCEDURE GetArtistSongs(IN artist_id INT UNSIGNED, OUT song_title VARCHAR(100))
    BEGIN
        SELECT Song.Title INTO song_title
        FROM Song
        JOIN Song_Artist ON Song.SongID = Song_Artist.SongID
        WHERE Song_Artist.ArtistID = artist_id;
    END;
    //

CREATE PROCEDURE GetSongGenre(IN song_id INT UNSIGNED, OUT song_genre VARCHAR(50))
    BEGIN
        SELECT Song.Genre INTO song_genre
        FROM Song
        WHERE Song.SongID = song_id;
    END;
    //

CREATE PROCEDURE FindArtistGenre(IN artist_id INT UNSIGNED, OUT song_genre VARCHAR(50))
    BEGIN
        SELECT Song.Genre INTO song_genre
        FROM Song
        JOIN Song_Artist ON Song.SongID = Song_Artist.SongID
        WHERE Song_Artist.ArtistID = artist_id
        GROUP BY Song.Genre
        ORDER BY COUNT(*) DESC
        LIMIT 1;
    END;
    //

CREATE PROCEDURE GetSongDurationMinutes(IN song_id INT UNSIGNED, OUT song_duration_minutes SMALLINT UNSIGNED)
    BEGIN
        SELECT Song.Duration / 60 INTO song_duration_minutes
        FROM Song
        WHERE Song.SongID = song_id;
    END;
    //

CREATE PROCEDURE GetSongViews(IN song_id INT UNSIGNED, OUT song_views INT UNSIGNED)
    BEGIN
        SELECT Song.Views INTO song_views
        FROM Song
        WHERE Song.SongID = song_id;
    END;
    //

CREATE PROCEDURE GetArtistViews(IN artist_id INT UNSIGNED, OUT artist_total_views INT UNSIGNED)
    BEGIN
        SELECT Artist.TotalViews INTO artist_total_views
        FROM Artist
        WHERE Artist.ArtistID = artist_id;
    END;
    //

CREATE PROCEDURE GetTopArtist(OUT artist_name VARCHAR(100))
    BEGIN
        SELECT Artist.ArtistName INTO artist_name
        FROM Artist
        ORDER BY Artist.TotalViews DESC
        LIMIT 1;
    END;
    //

CREATE PROCEDURE GetTopArtistByGenre(IN genre VARCHAR(50), OUT artist_name VARCHAR(100))
    BEGIN
        SELECT Artist.ArtistName INTO artist_name
        FROM Artist
        JOIN Song_Artist ON Artist.ArtistID = Song_Artist.ArtistID
        JOIN Song ON Song.SongID = Song_Artist.SongID
        WHERE Song.Genre = genre
        ORDER BY Artist.TotalViews DESC
        LIMIT 1;
    END;
    //

CREATE PROCEDURE FindLatestCommentsByGenre(IN genre_name VARCHAR(50), OUT comment_id INT UNSIGNED)
    BEGIN
        SELECT Comment.CommentID INTO comment_id FROM Comment
        JOIN Song ON Comment.SongID = Song.SongID
        WHERE Song.Genre = genre_name
        ORDER BY Comment.PostedDateTime DESC
        LIMIT 10;
    END;
    //
DELIMITER ;

-- =================================Queries===================================
-- TESTING DELETE TRIGGER
-- deleting user with public playlist
DELETE FROM User WHERE UserID = 1;
-- deleting user with private playlist
DELETE FROM User WHERE UserID = 3;
-- selecting playlists to check if they were deleted
SELECT * FROM Playlist WHERE PlaylistID = 1;
SELECT * FROM Playlist WHERE PlaylistID = 3;
-- deleting playlists to reset table
DELETE FROM Playlist WHERE PlaylistID = 1;
DELETE FROM Playlist WHERE PlaylistID = 3;

-- TESTING STORED PROCEDURES
-- testing GetPlaylistSongs
CALL GetPlaylistSongs(5, @song_title);
SELECT @song_title;
-- testing GetSongArtist
CALL GetSongArtist(1, @artist_name);
SELECT @artist_name;
-- testing GetArtistSongs
CALL GetArtistSongs(1, @song_title);
SELECT @song_title;
-- testing GetSongGenre
CALL GetSongGenre(1, @song_genre);
SELECT @song_genre;
-- testing FindArtistGenre
CALL FindArtistGenre(1, @song_genre);
SELECT @song_genre;
-- testing GetSongDurationMinutes
CALL GetSongDurationMinutes(1, @song_duration_minutes);
SELECT @song_duration_minutes;
-- testing GetSongViews
CALL GetSongViews(1, @song_views);
SELECT @song_views;
-- testing GetArtistViews
CALL GetArtistViews(1, @artist_total_views);
SELECT @artist_total_views;
-- testing GetTopArtist
CALL GetTopArtist(@artist_name);
SELECT @artist_name;
-- testing GetTopArtistByGenre
CALL GetTopArtistByGenre('Pop', @artist_name);
SELECT @artist_name;
-- testing FindLatestCommentsByGenre
CALL FindLatestCommentsByGenre('Pop', @comment_id);
SELECT @comment_id;