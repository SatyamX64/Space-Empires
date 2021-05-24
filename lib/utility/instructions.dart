const Map<String, String> kInstructionsData = const {
  'Game Story':
      'The solar system was always full of strange and powerful organisms, fighting for survival. This war has been going on for ages, some races adapted and improvised, the ones that couldn\'t, perished.\n\nFour races, in particular, have emerged on top. They practically rule the whole system. The world is witnessing peace for now, but that tension among the 4 rulers to come on top still stands.\n\nSeveral Prophecies and studies were made that point to the potential destruction of the complete Solar System, but no evidence or concrete proof has been found yet.\nAlthough it all changes one day… when I dream',
  'Overview':
      'SE (space empires) is a turn-based strategy game, where you play as the ruler for your race against 3 other races in a battle for domination in the galaxy spine.\n\nEach race starts with 2 planets out of 8. Your goal is to have all 8 under your command, you lose when you\'ve got no planets left.\nThe main map gives you a look at the sector, here you can see the planets in the sector and give your planets commands.\nIn the Control Deck at the bottom, you can give different commands.\nAt any time you can click on the snooze button for help. The Starting planets depend on your race.\n\nThis game is turn-based. That means you can play only on your turn.\n\nAt your turn, you can do one of the following: \n  - Giving your planets new orders \n  - Talk with the other races \n  - Building new ships for your attack fleet \n  - Attack an enemy planet \n\nAfter you do all you want, click on the "Next Turn" button at the bottom center, to pass the turn to the other races.\nAll the races can do to you whatever you can at their turn.\nAfter they\'ll finish- it will be your turn again. ',
  'Planets Overview':
      'Planets are the most important asset in the game since they are the main way to gain money.\nClicking on a planet that is under your control will open the planet\'s menu.',
  'Buildings':
      'In order to improve your planet\'s money output per turn, to improve their inhabitant\'s morale (see morale next), or to get general benefits, you can build buildings on your planets.\n\nClick on "Upgrades" from the planet menu of the planet you want to build on.\nIt will take you to the Upgrades menu, where you can choose which building to build, click on the building picture to build it.\n(first, make sure you have enough money for it).\n\n* The gun and the turret will give this planet higher defense in case of invasion.\n* The market and the trade center will improve the planet Ac output.\n\nYou\'ll learn about the rest of the buildings later.',
  'Defense Ships':
      'Since holding the planets is the goal of SE you must do everything to ensure that your planets will stay in your hand.\nAll the other races wish to take over your planets and might try to invade them from time to time. If you have enough def. ships on the attacked planet, you will manage to drive away their attacks.\n\nYou build defense ships by clicking "Defense" in the planet menu. This will take you to the def ships menu, where you can choose what ship to buy.\nThere are 3 types of ships to buy. \n\nNotice: Each planet has its own defense ships, and they cannot be moved from one planet to another. Also, they can\'t be used to attack enemy planets, but only to protect the planet they were built on.\nAlso be aware that def ship like attack ships demands some maintenance per turn.',
  'Planet Morale':
      'A planet\'s morale level grades the happiness of the people who live on that planet. You can see a planet morale level by clicking "Stats" in the planet menu.\n\nAs long as the planet\'s morale is above 400 it\'s ok, but if it goes below it that might cause its settlers to go on a strike or even revolt.\n\nYou can improve the people\'s morale by building a Town Center and a Moske, but most important is to bust up the luxury funds. If the morale goes too low you\'ll see one mark next to the planet on the main map. A strike will reduce planet revenue, and a revolt will completely stop it.\n\nAnother cause for resentment is your army. Every attack ship you build and war against other races might reduce your people\'s morale.\nTo fight anti-war resentment, you need to increase your propaganda funds to convince the people to support you. You need to do that only if there\'s resentment from war or the army.\nThis won\'t improve the morale otherwise since it only reduces the effects of the war on your people.\n\nNotice: Only attack fleet causes resentment, so you can build def fleet freely.',
  'Economy':
      'Money is needed to do anything in SE, from buying ships to maintaining the peace. You gain money from your planets.\nEach planet gives you a certain amount of money per turn, you can also get additional money from trading with other races.\n\nIn the control deck click on the "stats" button. This will bring you to the stats panel.\nIn here you can see how much money you\'ll get next turn, and choose how much money you have invested in these stats : \n\n*Military- Decreases Ship maintainence\n*Culture- Improve the attitude of the alliens\n*Propaganda- Invest only if there\'s anti war resentment.\nNote - Invest as much as needed to gain back your people support (The more ata. ships you have, the more prop you need).\n*Luxury- you need about 40 per planet to keep the morale balanced, but invest more if needed.',
  'Fight Overview':
      'A battle always occur when one race attacks another race\'s planet. In that situation- the attacker\'s Attack fleet faces the Defence fleet of the planet they attack.\nEither the attacker will win and the planet will turn to his control, or the defender will manage to drive the attack away.\n\nAnyway, both to try to invade a planet, or to be in a threat of invasion by an alien race, you must be at war with that alien race.',
  'Fight - Attack Fleet':
      'You can buy 3 types of attack ships.\n\nNotice: like def ships, attack ships also need the support of a certain amount of money per turn.\nAttack ships are needed to Invade other planets, so the more attack ships you have, the more greater your chances for a successful invasion.\n\nAtack ships also deter your enemies from attacking you. The more you have, the stronger you are.',
  'War':
      'If you want to attack an enemy planet, press the "attack planet" button on the control deck, and choose a planet to attack. After you select a planet to attack, or an enemy has attacked one of your planets, the battle menu will open.\n\nNotice: If attacker aborts midway, they might still lose some of the ships by the defenders\n\nEither if you are attacking or defending you\'ll get to the battle screen next. \nA battle, like the game, is turn-based, each turn you choose the way your ships will fight, and clicking "Attack", to the next turn.\nThe attacker\'s attack fleet will face the planet defense fleet, the one who is left with no ships, loses the battle.\n\nIf the defender lost, the attacker gains control on that planet.',
  'Diplomacy':
      'There are 3 diplomatic states possible with each of the other races.\n\nWar- two races fighting each other.\n\nPeace- No fighting is allowed.\n\nTrade- Like peace, only there\'s trading, that gives you more money per turn.\n\nTo contact another race, click on the diplomacy button in the control deck, then choose the race you want to speak with. There, you can try to improve your relations, declare war, and other things.',
  'Diplomacy-Attitude':
      'The other ruler\'s attitude towards you affects the chances for making peace, signing a trade pact, coming to your aid when you\'re in trouble, and declaring war on you.\nThe better it is the higher the chances they will not get in a war with you.\nAttitude is determined by the following:\n\n* Culture funds at the economy menu- That will increase your popularity among the other races and will also affect the morale if it drops too low. Try not to get less than 40 points, and invest more if you have to.\n\n*Trade Center- building them on your planet will improve your negotiation ability\n\nTrust- Each time you declare war without a reason, the aliens trust you a bit less, it\'s very hard to restore their trust, so be careful with this.',
  'Diplomacy-Determent':
      'The bigger army you have, and the higher your fighting level is, the more the aliens will fear you.\nThe more they fear you the lower the chances they will dare to declare war on you. That\'s why it is important to build an army even if you\'re not planning an attack soon.\n\nNotice: Some actions may cause a diplomatic crisis or cause an alien race to hate you so much that culture funds won\'t help in improving their attitude. In that case, the best you can do is to try giving them a gift as a token of friendship.',
};
