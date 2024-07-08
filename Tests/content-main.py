#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2019 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

import unittest

import html_unit_test


class MyTests(html_unit_test.TestCase):
    def test_main(self):
        input_fn = 'dest/post-incs/t2/philosophy/philosophy/' + \
            'putting-cards-on-the-table-2019-2020/index.xhtml'
        doc = self.doc(input_fn)

        doc.has_one(
            ".//h4[@id='fox-in-the-hens-coop' and " +
            "text()='The Fox in the Chickens Coop']"
        )
        doc.has_one(
            ".//section[header/h3[@id='hacking-heroism']]"
        )
        doc.has_one(
            ".//nav[@class='page_toc']//ul/li[a[@href='#hakuna-matata']]"
            "[preceding-sibling::li"
            "[a[@href='#time-is-much-more-important-than-money']]"
            "]"
        )

    def test_docbook5_youtube_video(self):
        input_fn = 'dest/post-incs/t2/philosophy/philosophy/' + \
            'putting-cards-on-the-table-2019-2020/index.xhtml'
        doc = self.doc(input_fn)
        query = doc.xpath(".//iframe")
        found = False
        for node in query.xpath_results:
            if node.get('src') == "https://www.youtube.com/embed/srwxJUXPHvE":
                found = True
                break
        self.assertTrue(found, "Found a youtube song in an iframe")

    def test_share_this_url(self):
        input_fn = './dest/post-incs/t2/humour/bits/' + \
            'Atom-Text-Editor-edits-2_000_001-bytes/index.xhtml'
        doc = self.doc(input_fn)
        doc.has_one(
            ".//p[@class='share']/a[@href='" +
            "http://www.addtoany.com/share_save?linkurl=https%3A%2F%2F" +
            "www.shlomifish.org%2Fhumour%2Fbits%2FAtom-Text-Editor" +
            "-edits-2_000_001-bytes%2F&linkname=']"
        )

    def test_fanfic(self):
        input_fn = 'dest/post-incs/t2/philosophy/culture/' + \
            'case-for-commercial-fan-fiction/indiv-nodes/' + \
            'learning_more_from_inet_forums.xhtml'
        doc = self.doc(input_fn)
        xp = doc.xpath('//*/text()')
        self.assertEqual(
            [x for x in xp.xpath_results if (("b'" in x) or ("\\'" in x))],
            [],
            "no double quoting",
        )

    def test_fanfic_link(self):
        input_fn = 'dest/post-incs/t2/philosophy/culture/' + \
            'case-for-commercial-fan-fiction/indiv-nodes/' + \
            'starved_of_employees.xhtml'
        doc = self.doc(input_fn)
        xp = doc.xpath("//a[text()='attractive and competent actors']")
        self.assertEqual(
            len(xp),
            1,
            "no double quoting",
        )
        self.assertEqual(
            xp.xpath_results[0].get('href'),
            '../#beautiful_people_are_geeks',
            "href results",
        )

    def test_root_page_has_hosting_link(self):
        input_fn = './dest/post-incs/t2/index.xhtml'
        self.doc(input_fn).has_one(
            ".//footer//a[@href = 'meta/hosting/#hostgator']/"
            + "img[@src='images/hostgator.png' and @alt='Hosted at HostGator']"
        )

    def test_site_map(self):
        input_fn = './dest/post-incs/t2/site-map/index.xhtml'
        self.doc(input_fn).has_one(
            ".//div[@class='sitemap']/ul/li[a[@href='../humour/']]" +
            "/ul/li/a[@href='../humour/aphorisms/']"
        )

    def test_fortunes_page__published_elem(self):
        input_fn = ('./dest/post-incs/t2/humour/fortunes/'
                    '__FORTS-show-cgi-xhtmls/windows-minus-minus.xhtml')
        d = self.doc(input_fn)
        d.has_one(
            ".//table/tbody/tr/td[@class='field' and text()='Published']"
        )

    def test_factoids_fortune_page__h3_elem(self):
        input_fn = './dest/post-incs/t2/humour/fortunes/shlomif-factoids.html'
        d = self.doc(input_fn)
        d.has_one(
            ".//h3[@id='shlomif-fact-xena-1' and " +
            "text()='Shlomi Fish’s Xena the Warrior Princess Fact #1']"
        )
        d.has_one(
            ".//blockquote[p[contains(text(), 'Summer Glau can get more with"
            " a kind word alone than Al Capone could with a kind"
            " word and a gun.')]]"
        )

    def test_hebrew_site_map(self):
        input_fn = './dest/post-incs/t2/site-map/hebrew/index.xhtml'
        doc = self.doc(input_fn)

        sect = ".//section[header/*/@id='sitemap']"
        doc.has_one(
            sect +
            "/ul/li[a[@href='../../humour/']]" +
            ""
            )

        doc.has_one(
            sect +
            "/ul/li[a[@href='../../humour/']]" +
            "/ul/li[a[@href='../../humour/stories/']]" +
            "/ul/li[a[@href='../../humour/stories/usable/']]" +
            "/ul/li[a[@href='../../humour/TheEnemy/']]" +
            "/ul/li[a[contains(@href, " +
            "'../../humour/TheEnemy/The-Enemy-Hebrew')]]" +
            ""
            )

    def test_faq_inner_links(self):
        input_fn = \
            './dest/post-incs/t2/meta/FAQ/atheism_can_be_a_religion.xhtml'
        doc = self.doc(input_fn)
        doc.has_count(".//a[@href='./#religious_belief']", 2)

    def test_rindolfism(self):
        input_fn = \
            './dest/post-incs/t2/me/rindolfism/index.xhtml'
        doc = self.doc(input_fn)
        doc.has_none(
            ".//section[header/*/@id='neo_semitism']" +
            "/section[header/*/@id='rindolfism_canon']")
        doc.has_one(
            ".//section[header/*/@id='rindolfism']" +
            "/section[header/*/@id='rindolfism_canon']")

    def test_selina_mandrake_logo(self):
        input_fn = './dest/post-incs/t2/humour/Selina-Mandrake/index.xhtml'
        self.doc(input_fn).has_one(
            ".//img[@id='selina_mandrake_logo' and " +
            "@src='images/Green-d10-dice.webp']"
        )

    def test_factoids_main_page(self):
        input_fn = './dest/post-incs/t2/humour/bits/facts/index.xhtml'
        doc = self.doc(input_fn)
        res = doc.xpath(
            ".//section[@class='h3 facts']"
        )
        self.assertTrue((len(res) > 6), "len(facts)")
        for el in res.xpath_results:
            a_el = el.xpath(
                "./header/h3/a"
            )
            self.assertEqual(len(a_el), 1, "len")
            self.assertTrue(
                a_el[0].get("href").endswith("/"),
                "trailing slash for directory link"
            )
            self.assertFalse(
                a_el[0].text.endswith("atire]"),
                "[Satire] title",
            )

    def test_hhgg_st_tng(self):
        input_fn = (
            './dest/post-incs/t2/humour/' +
            'by-others/hitchhiker-guide-to-star-trek-tng-htmlised.html'
        )
        self.doc(input_fn).has_one(
            ".//section[header/h2[@id='about']]/descendant::p" +
            "[contains(text(),'This is an HTMLised version')]",
            "describes HTMLised in about",
            )

    def test_road2heaven(self):
        input_fn = './dest/post-incs/t2/humour/RoadToHeaven/abstract.xhtml'
        self.doc(input_fn).has_one(
            ".//li[contains(" +
            "text(),'החבר לשעבר מחליט שקבוצה מייצגת של חברים לשעבר')]"
        )

    def test_tagline_on_stories_page(self):
        input_fn = './dest/post-incs/t2/humour/stories/index.xhtml'
        self.doc(input_fn).has_one(
            ".//article[@class='story' and " +
            ".//h3/@id='summerschool-at-the-nsa']/p[@class='tagline' " +
            "and contains(text(), 'As the sling shoots')]")

    def test_anchor_link(self):
        input_fn = (
            './dest/post-incs/t2/humour/Terminator/Liberation/' +
            'indiv-nodes/hamlet-parody-Cher-parody.xhtml'
        )
        self.doc(input_fn).has_one(
            ".//a[@href='../ongoing-text.html#emulating-arnie-as-hamlet'"
            "and text()='the Hamlet parody scene']"
        )

    def test_old_news(self):
        input_fn = './dest/post-incs/t2/old-news.html'

        self.doc(input_fn).has_one(
            ".//article["
            "@class='news_item' and "
            "descendant::h3[@id='shlomifish.org_news_2014_10_05'] and "
            "descendant::a[contains(@href, '/So-Who-The-Hell-Is-Qoheleth/')]"
            "]"
        )

    def _factoids_check_helper(self, input_fn, htmlid, doc=None):
        (doc or self.doc(input_fn)).has_one(
            ".//a[contains(@href, 'humour/fortunes/shlomif-factoids.html#"
            + htmlid + "')"
            + "and text()='These factoids in XML-Grammar-Fortune format']"
        )

    def test_chuck_factoids_link(self):
        input_fn = (
            './dest/post-incs/t2/humour/bits/facts/Chuck-Norris/index.xhtml'
        )
        self._factoids_check_helper(
            input_fn=input_fn, htmlid='shlomif-fact-chuck-1'
        )

    def test_emma_watson_factoids_link(self):
        input_fn = (
            './dest/post-incs/t2/humour/bits/facts/Emma-Watson/index.xhtml'
        )
        doc = self.doc(input_fn)
        self._factoids_check_helper(
            input_fn=input_fn, htmlid='shlomif-fact-emma-watson-1',
            doc=doc,
        )
        res = doc.xpath(
            ".//a[contains(text(), 'the Wikipedia page')]"
        )
        self.assertTrue((len(res) > 0), "len(facts)")
        node = res.xpath_results[0]
        self.assertIn("wikipedia.org", node.get('href'))

    def test_in_soviet_russia_factoids_link(self):
        input_fn = (
            './dest/' +
            'post-incs/t2/humour/bits/facts/In-Soviet-Russia/index.xhtml'
        )
        self._factoids_check_helper(
            input_fn=input_fn, htmlid='shlomif-fact-soviet-russia-1'
        )

    def test_larry_wall_factoids_link(self):
        input_fn = (
            './dest/post-incs/t2/humour/bits/facts/Larry-Wall/index.xhtml'
        )
        self._factoids_check_helper(
            input_fn=input_fn, htmlid='shlomif-fact-larry-wall-fact-1'
        )

    def test_sglau_factoids_link(self):
        input_fn = (
            './dest/post-incs/t2/humour/bits/facts/Summer-Glau/index.xhtml'
        )
        self._factoids_check_helper(
            input_fn=input_fn, htmlid='shlomif-fact-sglau-1'
        )

    def test_windows_update_factoids_link(self):
        input_fn = (
            './dest/post-incs/t2/humour/bits/facts/Windows-Update/index.xhtml'
        )
        self._factoids_check_helper(
            input_fn=input_fn, htmlid='shlomif-fact-win-update-1'
        )

    def test_queen_padme_screenplay(self):
        input_fn = (
            './dest/post-incs/t2/humour/Queen-Padme-Tales/'
            'Queen-Padme-Tales--Queen-Amidala-vs-the-Klingon-Warriors.html'
        )
        self.doc(input_fn).has_one(
            ".//*[@id='queen_padme_tales__abstract']"
        )
        input_fn = (
            './dest/post-incs/t2/humour/Queen-Padme-Tales/index.xhtml'
        )
        self.doc(input_fn).has_one(
            ".//*[@id='queen_padme_tales__abstract']"
        )

    def test_screenplay_style(self):
        input_fn = (
            './dest/post-incs/t2/humour/Terminator/Liberation/' +
            'ongoing-text.html'
        )
        self.doc(input_fn).has_one(
            ".//main[contains(@class, 'screenplay_style')]"
        )

    def test_bluerabbit(self):
        input_fn = 'dest/post-incs/t2/humour/Blue-Rabbit-Log/index.xhtml'
        self.doc(input_fn).has_one(
            ".//head/link[@rel='next' and @href='part-1.html']",
        )

    def test_blogs_rel_next(self):
        input_fn = 'dest/post-incs/t2/me/blogs/index.xhtml'
        self.doc(input_fn).has_one(
            ".//head/link[@rel='next' and contains(@href, 'humour')]",
        )

    def test_philosophy_general_essays_block(self):
        input_fn = 'dest/post-incs/t2/philosophy/index.xhtml'
        doc = self.doc(input_fn)
        doc.has_one(".//section[./header/h3[@id='general-essays']]" +
                    "[.//article[./header/h5[@id='put_cards_2013'" +
                    " and " +
                    "(./a/text()" +
                    "='Putting all the Cards on the Table (2013)'" +
                    ")" +
                    "]]]")
        return


if __name__ == '__main__':
    from pycotap import TAPTestRunner
    suite = unittest.TestLoader().loadTestsFromTestCase(MyTests)
    TAPTestRunner().run(suite)
