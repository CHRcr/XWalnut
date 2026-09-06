'use strict';

// Targeted September review. See REVIEW-2026-09.md for scope and references.
// These are explicit corrections for the senses shown on the cards, not rules
// inferred from spelling (e.g. an -s suffix does not establish countability).
const verbForms = (past, present, third) => [
  { label: '过去式 / 过去分词', value: past },
  { label: '现在分词', value: present },
  { label: '第三人称单数', value: third },
];
const plural = (value) => ({ label: '复数', value });

module.exports = {
  // Repair source headwords BEFORE merging. The source records stay intact so
  // their import defects remain traceable; corrections must match exact keys.
  sourceHeadwordCorrections: {
    'arise (arose,': 'arise',
    'awake (awoke,': 'awake',
    'DVD (digital': 'DVD',
  },

  entryOverrides: {
    arise: {
      meanings: ['vi. 出现；发生；起身'],
      forms: [
        { label: '过去式', value: 'arose' },
        { label: '过去分词', value: 'arisen' },
        { label: '现在分词', value: 'arising' },
        { label: '第三人称单数', value: 'arises' },
      ],
    },
    awake: {
      meanings: ['adj. 醒着的；v. 醒来；唤醒'],
      forms: [
        { label: '过去式', value: 'awoke / awaked' },
        { label: '过去分词', value: 'awoken / awaked' },
        { label: '现在分词', value: 'awaking' },
        { label: '第三人称单数', value: 'awakes' },
      ],
    },
    DVD: { meanings: ['n. 数字多功能光盘；数码影碟'], forms: [plural('DVDs')] },
    random: { meanings: ['adj. 随机的；任意的'] },
    worried: { meanings: ['adj. 担忧的；焦虑的'] },
    zoom: {
      meanings: ['v. 快速移动；（镜头）变焦'],
      forms: verbForms('zoomed', 'zooming', 'zooms'),
    },
    campaign: {
      meanings: ['n. 活动；运动；战役；v. 开展运动；参加活动'],
      forms: [plural('campaigns'), ...verbForms('campaigned', 'campaigning', 'campaigns')],
    },
    process: {
      meanings: ['n. 过程；步骤；程序；v. 加工；处理'],
      forms: [plural('processes'), ...verbForms('processed', 'processing', 'processes')],
    },
    bond: {
      meanings: ['n. 联系；纽带；黏合剂；v. 结合；黏合'],
      forms: [plural('bonds'), ...verbForms('bonded', 'bonding', 'bonds')],
    },
    are: { meanings: ['v. 是（be 的现在时形式，用于 you 及复数主语）'] },
    cage: { meanings: ['n. 笼；鸟笼'] },
    crayon: { meanings: ['n. 蜡笔；蜡笔画'] },
    for: { meanings: ['prep. 为了；对于；适合于；conj. 因为'] },
    sweep: {
      meanings: ['v. 扫；打扫；席卷；掠过'],
      forms: verbForms('swept', 'sweeping', 'sweeps'),
    },
    then: { meanings: ['adv. 当时；然后；那么；于是'] },
    with: { meanings: ['prep. 和；与；用；带有；随着'] },

    // Clean reviewed import punctuation without inventing missing senses.
    abstract: { meanings: ['n. 摘要；概要；抽象；adj. 抽象的；深奥的'] },
    acid: { meanings: ['n. 酸（化学物质）'] },
    any: { meanings: ['pron. 任何一个；（用于疑问句、否定句）一些'] },
    apron: { meanings: ['n. 围裙'] },
    as: { meanings: ['adv. & conj. 像……一样；如同；因为；prep. 作为'] },
    bachelor: { meanings: ['n. 学士；单身汉'] },
    bench: { meanings: ['n. 长凳'] },
    broadcast: { meanings: ['v. 广播'] },
    burn: { meanings: ['v. 燃烧；使晒黑；n. 烧伤'] },
    business: { meanings: ['n. 商业；生意；事情；职责'] },
    cap: { meanings: ['n. 帽子；盖'] },
    club: { meanings: ['n. 俱乐部'] },
    coat: { meanings: ['n. 外套'] },
    conservative: { meanings: ['adj. 保守的；保守主义的；谨慎的'] },
    corporation: { meanings: ['n. 公司；企业；社团；法人'] },
    exact: { meanings: ['adj. 精确的；准确的'] },
    failure: { meanings: ['n. 失败；失败者；失败的事'] },
    far: {
      meanings: ['adj. 远的；adv. 远；遥远地'],
      forms: [
        { label: '比较级', value: 'farther / further' },
        { label: '最高级', value: 'farthest / furthest' },
      ],
    },
    mankind: { meanings: ['n. 人类'] },
    media: { meanings: ['n. 媒体'] },
    note: { meanings: ['n. 便条；笔记；注释；钞票；音符；音调；v. 记下'] },
    over: { meanings: ['prep. 在……上方；越过；遍及；adv. 翻倒；越过'] },
    part: { meanings: ['n. 部分；成分；角色；零件；adj. 部分的；v. 分离'] },
    pole: { meanings: ['n. 杆；电线杆'] },
    start: { meanings: ['v. 开始；着手；出发；惊起；n. 开始；惊起'] },
    wear: { meanings: ['v. 穿着；戴；留蓄；带着；表现出；磨损'] },

    // Use uncountable forms for the ordinary senses currently displayed.
    // Specialist plurals (types of rice/music, legal moneys, etc.) are not
    // presented as generic inflections of these school-level meanings.
    baggage: { forms: [] },
    equipment: { forms: [] },
    homework: { forms: [] },
    knowledge: { forms: [] },
    music: { forms: [] },
    weather: { forms: [] },
    scenery: { forms: [] },
    rice: { forms: [] },
    bread: { forms: [] },
    money: { forms: [] },
    research: { forms: [] },
    permission: { forms: [] },
    accommodation: { forms: [{ label: '美式英语（住宿）', value: 'accommodations' }] },

    // Equal spelling is still a useful inflection, not a duplicate to drop.
    put: { forms: verbForms('put', 'putting', 'puts') },
    cut: { forms: [plural('cuts'), ...verbForms('cut', 'cutting', 'cuts')] },
    hit: { forms: [plural('hits'), ...verbForms('hit', 'hitting', 'hits')] },
    hurt: { forms: verbForms('hurt', 'hurting', 'hurts') },
    let: { forms: verbForms('let', 'letting', 'lets') },
    read: { forms: verbForms('read', 'reading', 'reads') },
    cost: { forms: [plural('costs'), ...verbForms('cost', 'costing', 'costs')] },
    shut: { meanings: ['v. 关上；关闭'], forms: verbForms('shut', 'shutting', 'shuts') },
    spread: { forms: verbForms('spread', 'spreading', 'spreads') },
    burst: { forms: verbForms('burst', 'bursting', 'bursts') },
    sheep: { forms: [plural('sheep')] },
    deer: { forms: [plural('deer')] },
    will: { forms: [{ label: '过去式（情态动词）', value: 'would' }] },
    shall: { forms: [{ label: '过去式（情态动词）', value: 'should' }] },
    may: { forms: [{ label: '过去式（情态动词）', value: 'might' }] },
  },

  familyAdditions: {
    resilience: { members: [['resilient', 'adj. 能从困难中恢复的；有弹性的']] },
  },

  phraseAssignments: {
    arise: ['arise from 由……引起；起因于'],
    awake: ['stay awake 保持清醒'],
    random: ['at random 随机地；任意地'],
    worried: ['be worried about 担心……'],
    zoom: ['zoom in / out 放大 / 缩小画面'],
    campaign: ['a campaign for 为争取……而开展的活动'],
    process: ['in the process of doing sth 在做某事的过程中'],
    equipment: ['a piece of equipment 一件设备'],
    homework: ['do homework 做家庭作业'],
    knowledge: ['acquire knowledge 获取知识'],
    music: ['listen to music 听音乐'],
    scenery: ['enjoy the scenery 欣赏风景'],
    bread: ['a slice of bread 一片面包'],
    permission: ['ask for permission 请求许可'],
    research: ['do research on 研究……'],
    read: ['read aloud 大声朗读'],
    resilience: ['build resilience 增强应对困难的韧性'],
  },
};
