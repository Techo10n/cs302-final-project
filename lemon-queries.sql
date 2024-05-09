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

CREATE PROCEDURE FindArtistGenre(IN artist_id INT UNSIGNED, OUT artist_genre VARCHAR(50))
    BEGIN
        SELECT Song.Genre INTO artist_genre
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