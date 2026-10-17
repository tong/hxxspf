import XSPFPlaylist;
import utest.Assert.*;

class TestXSPF implements utest.ITest {
	static var pl = XSPFPlaylist.parse(Xml.parse(haxe.Resource.getString("playlist")).firstElement());

	public function new() {}

	function test_parse_playlist() {
		equals("XSPF Example Playlist", pl.title);
		equals("tong", pl.creator);
		equals("This is an xspf-playlist example for testing.", pl.annotation);
		equals("http://xspf.org/xspf-v1.html", pl.info);
		equals("http://xspf.disktree.net/xspf_sample.xml", pl.location);
		equals("20eabe5d64b0e216796e834f52d61fd0b70332fc", pl.identifier);
		equals("http://download.disktree.net/music/sdk_sperrplan/GRAUESCHMIERE_cover.jpg", pl.image);
		equals("2008-01-08T17:10:23-05:00", pl.date);
		equals("CreativeCommons", pl.license);
		var attribution = [for (e in pl.attribution.elements()) e];
		equals(2, attribution.length);
		equals("location", attribution[0].nodeName);
		equals("http://disktree.net/modified_version_of_original_playlist.xspf", attribution[0].firstChild().nodeValue);
		equals("identifier", attribution[1].nodeName);
		equals("somescheme:original_playlist.xspf", attribution[1].firstChild().nodeValue);
		equals(1, pl.link.length);
		equals("http://disktree.example.org/namespace/version1", pl.link[0].rel);
		equals("http://disktree.net/bar/foo.rdfs", pl.link[0].content);
		equals(1, pl.meta.length);
		equals("duration", pl.meta[0].rel);
		equals("12.5", pl.meta[0].content);
	}

	function test_parse_tracklist() {
		equals("ARUK", pl.tracklist[0].title);
		equals("http://download.disktree.net/music/tong/ARUK.mp3", pl.tracklist[0].location[0]);

		equals("arturia_extended_5", pl.tracklist[1].title);
		equals("tong", pl.tracklist[1].creator);
		equals("http://download.disktree.net/music/tong/arturia_extended_5.mp3", pl.tracklist[1].location[0]);
		equals("http://spp.tt4.at", pl.tracklist[1].info);
		equals("http://download.disktree.net/music/sdk_sperrplan/GRAUESCHMIERE_cover.jpg", pl.tracklist[1].image);

		equals("ybot_e54_4_5", pl.tracklist[2].title);
		equals("DJ-mix by ytong at E54 (2005).", pl.tracklist[2].annotation);
		equals("http://www.spp.tt4.at", pl.tracklist[2].info);
		equals("http://download.disktree.net/music/tong/ybot_e54_4_5.mp3", pl.tracklist[2].location[0]);
		equals("http://download.disktree.net/music/sdk_sperrplan/GRAUESCHMIERE_cover.jpg", pl.tracklist[2].image);
		equals("http://disktree.example.org/namespace/version1", pl.tracklist[2].link[0].rel);
		equals("http://disktree.net/bar/foo.rdfs", pl.tracklist[2].link[0].content);

		equals("captions", pl.tracklist[2].meta[0].rel);
		equals("http://disktree.net/path.xml", pl.tracklist[2].meta[0].content);

		equals(3, pl.tracklist[2].meta.length);
		equals("duration", pl.tracklist[2].meta[2].rel);
		equals("00:00:45", pl.tracklist[2].meta[2].content);

		equals("http://example.com", pl.tracklist[2].extension[0].application);
		var clip = pl.tracklist[2].extension[0].content.firstElement();
		equals("cl:clip", clip.nodeName);
		equals("25000", clip.get("start"));
		equals("34500", clip.get("end"));
	}

	function test_roundtrip() {
		var src = Xml.parse(haxe.Resource.getString("playlist")).firstElement();
		var a = XSPFPlaylist.parse(src);
		var b = XSPFPlaylist.parse(Xml.parse(a.toXml().toString()).firstElement());
		equals(a.title, b.title);
		equals(a.creator, b.creator);
		equals(a.annotation, b.annotation);
		equals(a.info, b.info);
		equals(a.location, b.location);
		equals(a.identifier, b.identifier);
		equals(a.image, b.image);
		equals(a.date, b.date);
		equals(a.license, b.license);
		equals(a.attribution.toString(), b.attribution.toString());
		same(a.link, b.link);
		same(a.meta, b.meta);
		equals(a.tracklist.length, b.tracklist.length);
		for (i in 0...a.tracklist.length) {
			var ta = a.tracklist[i], tb = b.tracklist[i];
			same(ta.location, tb.location);
			equals(ta.title, tb.title);
			equals(ta.creator, tb.creator);
			equals(ta.annotation, tb.annotation);
			equals(ta.info, tb.info);
			equals(ta.image, tb.image);
			same(ta.link, tb.link);
			same(ta.meta, tb.meta);
			equals(ta.extension.length, tb.extension.length);
		}
		equals("cl:clip", b.tracklist[2].extension[0].content.firstElement().nodeName);
		// serializing must not detach nodes from the parsed playlist
		a.toXml();
		equals(2, [for (e in a.attribution.elements()) e].length);
		notNull(a.tracklist[2].extension[0].content.firstElement());
	}

	function test_escaping() {
		var p = new XSPFPlaylist();
		p.title = "A & B <c>";
		var t = new XSPFTrack();
		t.location.push("http://example.com/x?a=1&b=2");
		t.creator = "me";
		p.tracklist.push(t);
		var q = XSPFPlaylist.parse(Xml.parse(p.toXml().toString()).firstElement());
		equals("A & B <c>", q.title);
		equals("http://example.com/x?a=1&b=2", q.tracklist[0].location[0]);
		equals("me", q.tracklist[0].creator);
	}

	function test_empty_elements() {
		var p = XSPFPlaylist.parse(Xml.parse('<playlist version="1" xmlns="http://xspf.org/ns/0/"><title/><trackList><track><title/><duration/><extension application="x"/></track></trackList></playlist>')
			.firstElement());
		isNull(p.title);
		isNull(p.tracklist[0].title);
		isNull(p.tracklist[0].duration);
		equals("x", p.tracklist[0].extension[0].application);
	}

	function test_prefixed_namespace() {
		var p = XSPFPlaylist.parse(Xml.parse('<xspf:playlist version="0" xmlns:xspf="http://xspf.org/ns/0/"><xspf:title>T</xspf:title><xspf:trackList><xspf:track><xspf:title>X</xspf:title></xspf:track></xspf:trackList></xspf:playlist>')
			.firstElement());
		equals("T", p.title);
		equals("X", p.tracklist[0].title);
		raises(() -> XSPFPlaylist.parse(Xml.parse('<playlist version="1" xmlns="http://example.com/"><trackList/></playlist>').firstElement()));
	}
}
