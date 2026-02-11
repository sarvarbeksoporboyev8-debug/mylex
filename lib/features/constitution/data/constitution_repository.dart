import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/constitution_model.dart';

/// Repository for constitution data
class ConstitutionRepository {
  // Mock constitution data
  final List<ConstitutionSection> _sections = [
    ConstitutionSection(
      id: 'preamble',
      title: 'Muqaddima',
      order: 0,
      articles: [
        ConstitutionArticle(
          id: 'preamble_1',
          number: 0,
          content: '''O'zbekiston xalqi:

o'z taqdirini o'zi belgilash huquqini tantanali ravishda e'lon qilib;

demokratik huquqiy davlat barpo etishga intilishini bildirgan holda;

insonparvarlik tamoyillariga sodiqligini namoyon etib;

kelajak avlodlar oldidagi mas'uliyatini anglagan holda;

O'zbekiston Respublikasining ushbu Konstitutsiyasini qabul qiladi.''',
        ),
      ],
    ),
    ConstitutionSection(
      id: 'section_1',
      title: 'I bo\'lim. Asosiy qoidalar',
      order: 1,
      articles: [
        ConstitutionArticle(
          id: 'art_1',
          number: 1,
          content: 'O\'zbekiston — suveren demokratik respublika. Davlatning "O\'zbekiston Respublikasi" va "O\'zbekiston" degan nomlari bir xildir.',
          isBookmarked: true,
        ),
        ConstitutionArticle(
          id: 'art_2',
          number: 2,
          content: 'Davlat xalq irodasini ifoda etib, uning manfaatlariga xizmat qiladi. Davlat organlari va mansabdor shaxslar jamiyat va fuqarolar oldida mas\'uldirlar.',
        ),
        ConstitutionArticle(
          id: 'art_3',
          number: 3,
          content: 'O\'zbekiston Respublikasi o\'z hududining daxlsizligi va chegaralarining buzilmasligini ta\'minlaydi. O\'zbekiston Respublikasining hududiy yaxlitligiga tajovuz qilish va uning chegaralarini o\'zgartirish maqsadida harakat qilish davlatga xiyonat deb hisoblanadi.',
        ),
        ConstitutionArticle(
          id: 'art_4',
          number: 4,
          content: 'O\'zbekiston Respublikasining davlat tili o\'zbek tilidir.\n\nO\'zbekiston Respublikasi o\'z hududida istiqomat qiluvchi barcha millat va elatlarning tillari, urf-odatlari va an\'analarini hurmat qilishni ta\'minlaydi, ularning rivojlanishi uchun sharoit yaratadi.',
        ),
        ConstitutionArticle(
          id: 'art_5',
          number: 5,
          content: 'O\'zbekiston Respublikasi o\'zining Davlat ramzlari — bayrog\'i, gerbi va madhiyasiga ega bo\'lib, ular qonun bilan belgilanadi.',
        ),
        ConstitutionArticle(
          id: 'art_6',
          number: 6,
          content: 'O\'zbekiston Respublikasining poytaxti — Toshkent shahri.',
        ),
      ],
    ),
    ConstitutionSection(
      id: 'section_2',
      title: 'II bo\'lim. Inson va fuqaroning asosiy huquqlari, erkinliklari va burchlari',
      order: 2,
      articles: [
        ConstitutionArticle(
          id: 'art_18',
          number: 18,
          content: 'O\'zbekiston Respublikasida barcha fuqarolar bir xil huquq va erkinliklarga ega bo\'lib, jinsi, irqi, millati, tili, dini, ijtimoiy kelib chiqishi, e\'tiqodi, shaxsi va ijtimoiy mavqeidan qat\'i nazar, qonun oldida tengdirlar.\n\nImtiyozlar faqat qonun bilan belgilanadi hamda ijtimoiy adolat tamoyillariga mos bo\'lishi kerak.',
          isBookmarked: true,
        ),
        ConstitutionArticle(
          id: 'art_19',
          number: 19,
          content: 'O\'zbekiston Respublikasi fuqarosi va davlat o\'zaro huquqlar va o\'zaro burchlar bilan bog\'liqdir.\n\nFuqarolarning Konstitutsiya va qonunlarda mustahkamlangan huquqlari va erkinliklari daxlsizdir, ularni sud qarorisiz hech kim mahrum eta olmaydi yoki cheklay olmaydi.',
        ),
        ConstitutionArticle(
          id: 'art_20',
          number: 20,
          content: 'Fuqarolarning huquq va erkinliklarini amalga oshirish jamiyat va davlatning, boshqa fuqarolarning huquqlari va qonuniy manfaatlariga putur yetkazmasligi kerak.',
        ),
        ConstitutionArticle(
          id: 'art_24',
          number: 24,
          content: 'Yashash huquqi har bir insonning daxlsiz huquqidir. Inson hayotiga suiqasd qilish eng og\'ir jinoyatdir.',
        ),
        ConstitutionArticle(
          id: 'art_25',
          number: 25,
          content: 'Har bir shaxs erkinlik va shaxsiy daxlsizlik huquqiga ega.\n\nHech kim qonunga asoslanmagan holda hibsga olinishi yoki qamoqda saqlanishi mumkin emas.',
        ),
        ConstitutionArticle(
          id: 'art_26',
          number: 26,
          content: 'Jinoyat sodir etganlikda ayblanayotgan har bir shaxs uning aybi qonunda belgilangan tartibda isbotlanmaguncha va sud hukmi qonuniy kuchga kirmaguncha aybsiz hisoblanadi.\n\nAyblanuvchiga o\'zini himoya qilish uchun barcha imkoniyatlar beriladi.',
        ),
        ConstitutionArticle(
          id: 'art_29',
          number: 29,
          content: 'Har kim o\'z sha\'ni va obro\'siga bo\'lgan tajovuzlardan, shaxsiy hayotiga aralashishdan himoyalanish va turar joyi daxlsizligi huquqiga ega.\n\nHech kim qonunda nazarda tutilgan hollardan va tartibdan tashqari birovning turar joyiga uning roziligisiz kirishi mumkin emas.',
        ),
      ],
    ),
    ConstitutionSection(
      id: 'section_3',
      title: 'III bo\'lim. Jamiyat va shaxs',
      order: 3,
      articles: [
        ConstitutionArticle(
          id: 'art_53',
          number: 53,
          content: 'Oila jamiyatning asosiy bo\'g\'inidir va jamiyat hamda davlat muhofazasida bo\'lish huquqiga ega.\n\nNikoh faqat er va xotinning o\'zaro roziligi bilan tuziladi. Er-xotin oilaviy munosabatlarda teng huquqlidirlar.',
        ),
        ConstitutionArticle(
          id: 'art_54',
          number: 54,
          content: 'Ota-onalar o\'z farzandlarini voyaga yetgunlariga qadar boqish va tarbiyalashga majburdirlar.\n\nDavlat va jamiyat yetim bolalarni va ota-ona qaramog\'idan mahrum bo\'lgan bolalarni boqish, tarbiyalash va o\'qitishni ta\'minlaydi, bolalarga bag\'ishlangan xayriya faoliyatini rag\'batlantiradi.',
        ),
        ConstitutionArticle(
          id: 'art_55',
          number: 55,
          content: 'Voyaga yetgan, mehnatga layoqatli farzandlar o\'z ota-onalari haqida g\'amxo\'rlik qilishga majburdirlar.',
        ),
      ],
    ),
    ConstitutionSection(
      id: 'section_4',
      title: 'IV bo\'lim. Ma\'muriy-hududiy va davlat tuzilishi',
      order: 4,
      articles: [
        ConstitutionArticle(
          id: 'art_68',
          number: 68,
          content: 'O\'zbekiston Respublikasi viloyatlar, tumanlar, shaharlar, shaharchalar, qishloqlar, ovullardan, shuningdek Qoraqalpog\'iston Respublikasidan iborat.\n\nO\'zbekiston Respublikasining hududiy yaxlitligi va chegaralari daxlsiz va buzilmasdir.',
        ),
        ConstitutionArticle(
          id: 'art_70',
          number: 70,
          content: 'Qoraqalpog\'iston Respublikasi O\'zbekiston Respublikasi tarkibidagi suveren respublikadir.\n\nQoraqalpog\'iston Respublikasining suverenitetini O\'zbekiston Respublikasi himoya qiladi.',
        ),
        ConstitutionArticle(
          id: 'art_71',
          number: 71,
          content: 'Qoraqalpog\'iston Respublikasi o\'z Konstitutsiyasiga ega.\n\nQoraqalpog\'iston Respublikasining Konstitutsiyasi O\'zbekiston Respublikasining Konstitutsiyasiga muvofiq bo\'lishi kerak.',
        ),
      ],
    ),
    ConstitutionSection(
      id: 'section_5',
      title: 'V bo\'lim. Davlat hokimiyatini tashkil etish',
      order: 5,
      articles: [
        ConstitutionArticle(
          id: 'art_76',
          number: 76,
          content: 'O\'zbekiston Respublikasining Oliy Majlisi oliy davlat vakillik organi bo\'lib, qonun chiqaruvchi hokimiyatni amalga oshiradi.\n\nO\'zbekiston Respublikasining Oliy Majlisi ikki palatadan — Qonunchilik palatasi (quyi palata) va Senatdan (yuqori palata) iborat.',
        ),
        ConstitutionArticle(
          id: 'art_89',
          number: 89,
          content: 'O\'zbekiston Respublikasining Prezidenti davlat boshlig\'idir va davlat hokimiyati organlarining kelishilgan holda faoliyat yuritishini hamda hamkorligini ta\'minlaydi.',
        ),
        ConstitutionArticle(
          id: 'art_90',
          number: 90,
          content: 'O\'zbekiston Respublikasining Prezidenti bo\'lib tug\'ilishidan O\'zbekiston Respublikasi fuqarosi bo\'lgan, saylov kuni 35 yoshga to\'lgan, davlat tilini yaxshi biladigan, saylovgacha kamida 10 yil O\'zbekiston hududida doimiy istiqomat qilib kelayotgan shaxs saylanishi mumkin.\n\nAyni bir shaxs ketma-ket ikki muddatdan ortiq O\'zbekiston Respublikasining Prezidenti bo\'lishi mumkin emas.',
        ),
        ConstitutionArticle(
          id: 'art_98',
          number: 98,
          content: 'O\'zbekiston Respublikasining Vazirlar Mahkamasi ijro etuvchi hokimiyatni amalga oshiradi. O\'zbekiston Respublikasining Vazirlar Mahkamasi O\'zbekiston Respublikasining Hukumatidir.',
        ),
      ],
    ),
  ];

  Future<List<ConstitutionSection>> getSections() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _sections;
  }

  Future<ConstitutionSection?> getSectionById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _sections.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<ConstitutionArticle>> searchArticles(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowerQuery = query.toLowerCase();
    final results = <ConstitutionArticle>[];

    for (final section in _sections) {
      for (final article in section.articles) {
        if (article.content.toLowerCase().contains(lowerQuery)) {
          results.add(article);
        }
      }
    }

    return results;
  }

  Future<List<ConstitutionArticle>> getBookmarkedArticles() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final results = <ConstitutionArticle>[];

    for (final section in _sections) {
      for (final article in section.articles) {
        if (article.isBookmarked) {
          results.add(article);
        }
      }
    }

    return results;
  }

  Future<void> toggleBookmark(String articleId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    for (var i = 0; i < _sections.length; i++) {
      for (var j = 0; j < _sections[i].articles.length; j++) {
        if (_sections[i].articles[j].id == articleId) {
          final article = _sections[i].articles[j];
          _sections[i].articles[j] = article.copyWith(
            isBookmarked: !article.isBookmarked,
          );
          return;
        }
      }
    }
  }
}

/// Provider for constitution repository
final constitutionRepositoryProvider = Provider<ConstitutionRepository>((ref) {
  return ConstitutionRepository();
});

/// Provider for constitution sections
final constitutionSectionsProvider = FutureProvider<List<ConstitutionSection>>(
  (ref) async {
    final repository = ref.watch(constitutionRepositoryProvider);
    return repository.getSections();
  },
);

/// Provider for bookmarked articles
final bookmarkedArticlesProvider = FutureProvider<List<ConstitutionArticle>>(
  (ref) async {
    final repository = ref.watch(constitutionRepositoryProvider);
    return repository.getBookmarkedArticles();
  },
);
