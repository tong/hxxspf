
import XSPFPlaylist;
import utest.Assert.*;

class TestXSPF implements utest.ITest {

	static var pl = XSPFPlaylist.parse( Xml.parse( haxe.Resource.getString( "playlist" ) ).firstElement() );

    public function new() {}

    function test_parse_playlist() {

		equals( "XSPF Example Playlist", pl.title );
		equals( "tong", pl.creator );
		equals( "This is an xspf-playlist example for testing.", pl.annotation );
		equals( "http:/xspf.org/xspf-v1.html", pl.info );
		equals( "http:/xspf.disktree.net/xspf_sample.xml", pl.location );
		equals( "20eabe5d64b0e216796e834f52d61fd0b70332fc", pl.identifier );
		equals( "http://download.disktree.net/music/sdk_sperrplan/GRAUESCHMIERE_cover.jpg", pl.image );
		equals( "2008-01-08T17:10:23-05:00", pl.date );
		equals( "CreativeCommons", pl.license );
		var i = 0;
		for( node in pl.attribution ) {
			switch( i ) {
			case 0 :
				equals( "location", node.nodeName );
				equals( "http://disktree.net/modified_version_of_original_playlist.xspf", node.firstChild().nodeValue );
			case 1 :
				equals( "identifier", node.nodeName );
				equals( "somescheme:original_playlist.xspf", node.firstChild().nodeValue );
			}
			i++;
		}
		for( link in pl.link ) {
			equals( "http://disktree.example.org/namespace/version1", link.rel );
			equals( "http://disktree.net/bar/foo.rdfs", link.content );
		}
		for( meta in pl.meta ) {
			equals( "duration", meta.rel );
			equals( "12.5", meta.content );
		}
	}

	function test_parse_tracklist() {

		equals( "ARUK", pl.tracklist[0].title );
		equals( "http://download.disktree.net/music/tong/ARUK.mp3", pl.tracklist[0].location[0] );
	
		equals( "arturia_extended_5", pl.tracklist[1].title );
		equals( "tong", pl.tracklist[1].creator );
		equals( "http://download.disktree.net/music/tong/arturia_extended_5.mp3", pl.tracklist[1].location[0] );
		equals( "http://spp.tt4.at", pl.tracklist[1].info );
		equals( "http://download.disktree.net/music/sdk_sperrplan/GRAUESCHMIERE_cover.jpg", pl.tracklist[1].image );

		equals( "ybot_e54_4_5", pl.tracklist[2].title );
		equals( "DJ-mix by ytong at E54 (2005).", pl.tracklist[2].annotation );
		equals( "http://www.spp.tt4.at", pl.tracklist[2].info );
		equals( "http://download.disktree.net/music/tong/ybot_e54_4_5.mp3", pl.tracklist[2].location[0] );
		equals( "http://download.disktree.net/music/sdk_sperrplan/GRAUESCHMIERE_cover.jpg", pl.tracklist[2].image );
		equals( "http://disktree.example.org/namespace/version1", pl.tracklist[2].link[0].rel );
		equals( "http://disktree.net/bar/foo.rdfs", pl.tracklist[2].link[0].content );

		equals( "captions", pl.tracklist[2].meta[0].rel );
		equals( "http://disktree.net/path.xml", pl.tracklist[2].meta[0].content );

		equals( "http://example.com", pl.tracklist[2].extension[0].application );
		//TODO equals( '<cl:clip start="25000" end="34500" />', pl.tracklist[2].extension[0].content.toString() );

		/*
		var i = 0;
		for( track in pl.tracklist ) {
			switch( i ) {
			case 0 :
				equals( "ARUK", track.title );
				equals( "http://download.disktree.net/music/tong/ARUK.mp3", track.location[0] );

			case 1 :
				equals( "arturia_extended_5", track.title );
				equals( "tong", track.creator );
				equals( "http://download.disktree.net/music/tong/arturia_extended_5.mp3", track.location[0] );
				equals( "http://spp.tt4.at", track.info );
				equals( "http://download.disktree.net/music/sdk_sperrplan/GRAUESCHMIERE_cover.jpg", track.image );

			case 2 :
				equals( "ybot_e54_4_5", track.title );
				equals( "DJ-mix by ytong at E54 (2005).", track.annotation );
				equals( "http://www.spp.tt4.at", track.info );
				equals( "http://download.disktree.net/music/tong/ybot_e54_4_5.mp3", track.location[0] );
				equals( "http://download.disktree.net/music/sdk_sperrplan/GRAUESCHMIERE_cover.jpg", track.image );
				var j = 0;
				for( link in track.link ) {
					equals( "http://disktree.example.org/namespace/version1", link.rel );
					equals( "http://disktree.net/bar/foo.rdfs", link.content );
					j++;
				}
				j = 0;
				for( meta in track.meta ) {
					switch( j ) {
						case 0 :
							equals( "captions", meta.rel );
							equals( "http://disktree.net/path.xml", meta.content );
						case 1 :
							equals( "audio", meta.rel );
							equals( "http://download.disktree.net/music/tong/ybot_e54_4_5.mp3", meta.content );
						case 2 :
							equals( "duration", meta.rel );
							equals( "00:00:45", meta.content );
					}
					j++;
				}
				j = 0;
				for( extension in track.extension ) {
					equals( "http://example.com", extension.application );
					equals( Xml.parse( '<cl:clip start="25000" end="34500"/>' ).toString(), extension.content.toString() );
				}
			}
			i++;
            */
    }
}