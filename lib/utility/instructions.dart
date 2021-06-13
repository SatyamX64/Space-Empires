const Map<String, String> kInstructionsData = const {
  'Overview':
      '• This is a Turn-based Strategy game.\n\n• You play as the ruler for your race against 3 other races in a battle for domination in the galaxy spine.\n\n • The Game consist of 4 Players with 2 Planets each. \n\n• Your goal is to have all 8 under your command, you lose when you\'ve got no planets left.\n\n• Game Plays over 365 Turns/ Days',
  'Game-End':
      '• You Win if you take over all the 8 Planets.\n\n  PS: To take Over a Planet your must attack it and defeat its Ruler.\n\n• You lose if you get to day 0, i.e At end of 365 Turns\n\n• You lose if all your planets are taken over by someone',
  'Dashboard':
      '• The main map gives you a look at the solar system, here you can see the all planets with their rulers.\n\n • Tap on your Planets to access Planet Menu,\nPS : You can\'t access other ruler\'s Planet \n\n •Using The Control Deck at the bottom, you can give different commands.\nAt any time you can click on the info button for help.\n\n • The Current Day and your Money is displayed at top ',
  'Control Deck':
      '• Use the Control Deck to access following Panels\n\n  ‣ Attack Menu\n  ‣ Military Menu\n  ➼ Next Turn\n  ‣ Stats Menu\n  ‣ Global Chat',
  'Planets':
      '• Planets are the most important asset in the game since they are the main way to gain money.\n\n• Clicking on a planet that is under your control will open the planet\'s menu.\n\n• Here you can access :-\n\n  ‣Planet\'s Reports\n  ‣Planet\'s Upgrades\n  ‣Planet\'s Military',
  'Economy':
      '• Each owned Planet generates some Income per turn based upon the Planet Morale, Defense Expense, Buildings etc.\n\n• Money is needed to do anything in SE, from buying ships to maintaining the peace.\n\n• You gain money from your planets. Each planet gives you a certain amount of money per turn, you can also get additional money from trading with other races.\n\n• In the control deck click on the "Stats" button.\nIn here you can see how much money you\'ll get next turn',
  'Morale':
      '• A planet\'s morale level grades the happiness of the people who live on that planet.\n\n• As long as the planet\'s morale is above 400 it\'s ok, but if it goes below it that might cause its settlers to go on a strike.\n\n• You can improve the people\'s morale by building a Colesseum and a Starlink, but most important is to bust up the luxury funds.\n\n• If the morale goes too low you\'ll see one mark next to the planet on the main map. A strike will reduce planet revenue.\n\n• Another cause for resentment is your army. Every attack ship you build and war against other races might reduce your people\'s morale.\n\n•To fight anti-war resentment, you need to increase your propaganda funds to convince the people to support you.\nYou need to do that only if there\'s resentment from war or the army.\nThis won\'t improve the morale otherwise since it only reduces the effects of the war on your people.\n\n• Notice: Only attack fleet causes resentment, so you can build def fleet freely.',
  'Upgrades':
      '• In order to improve your planet\'s revenue, morale, or to get general benefits, you can build buildings on your planets.\n\n• Click on a building card to see its Info.\n\n• Buildings and their effects are not shared between your Planets\n\n• Buildings are destroyed if Planet is taken Over.',
  'Defense Ships':
      '• Since holding the planets is the goal of SE you must do everything to ensure that your planets will stay in your hand.\n\n• All the other races wish to take over your planets and might try to invade them from time to time.\n\n• If you have enough def. ships on the attacked planet, you will manage to drive away their attacks\n\n• Notice: Each planet has its own defense ships, and they cannot be moved from one planet to another\n\n• Also, they can\'t be used to attack enemy planets, but only to protect the planet they were built on.',
  'Turn':
      '• All the Actions available to you, are also available for the 3 Other rulers. At Start of every day all the Rulers will get there turn one by one.\n\n• The Day progresses after all the player\'s have completed their Turns.\n\n• Computer generally always gets the turn first.\n\n Pass the turn after you have completed eveything you want to do, by Clicking the next Turn Button.\n\n• At start of each day, you get incomes from all your planets.',
  'Attack':
      '• Here you can see all your Enemy Planets, tap on a Planet to attack it\n\n• Enemy Planets are those planets whose Ruler is in war with you\n\n• You can also see your Military Here\n\n\• You can only attack once per turn  ',
  'Military':
      '• Military is used to attack other Player. The more you have, the better your chances of a successful takeover.\n\n• Both Attack and Defense Ship demands some maintainence per turn, Attack Ship on top of that also affect the Morale\n\n• Selling a ships retrieves 80% of Cost',
  'Stats':
      '• There are 4 Major Stats :- \n\n‣ Propoganda - Counters Anti-war resentment on morale from Excess Military \n\n‣ Culture - Affects your GPI, use it to boost your likeability among other rulers.\n\n‣ Luxury - Directly affects your Planets Morale.\n\n‣ Military - Increases your attack Ships damage output and reduces maintainence cost.',
  'Global Chat':
      '• Here you can monitor your relation with other Rulers.\n\• You can only talk to a ruler once per turn. The possible actions are dependent on your relation with that ruler.\n\n•Relation can be like following \n\n• Peace - Both can\'t attack each other \n\n• War - Both can attack each other\n\n• Trade - Peace plus some extra money per turn\n\n• The More powerful you are, the better the Chances other rulers will agree to your request',
  'Fight Overview':
      '• A battle always occur when one race attacks another race\'s planet. In that situation- the attacker\'s Attack fleet faces the Defence fleet of the planet they attack.\n\n• Either the attacker will win and the planet will turn to his control, or the defender will manage to drive the attack away.\n\n• Anyway, both to try to invade a planet, or to be in a threat of invasion by an alien race, you must be at war with that alien race.',
  'Fight - Attack Fleet':
      '• You can buy 3 types of attack ships.\n\n• Notice: like def ships, attack ships also need the support of a certain amount of money per turn.\n\n• Attack ships are needed to Invade other planets, so the more attack ships you have, the more greater your chances for a successful invasion.\n\n• Atack ships also deter your enemies from attacking you. The more you have, the stronger you are.',
  'Fight - Formations':
      '• You can select differnt formations by sliding the numbers.\n\nAll the attack recieved at a positon will be given to the ship assigned there by your rival, The ships lost will roughly be (total damage/ health per ship).\n\n• You can see the Attack Ship stats from Military Panel, the defense ships of same class are generally a little better relatively',
  'War':
      '• If you want to attack an enemy planet, press the "attack planet" button on the control deck, and choose a planet to attack. After you select a planet to attack, or an enemy has attacked one of your planets, the battle menu will open.\n\n• Notice: If attacker aborts midway, they might still lose some of the ships by the defenders\n\n• Either if you are attacking or defending you\'ll get to the battle screen next.\n\n• A battle, like the game, is turn-based, each turn you choose the way your ships will fight, and clicking "Attack", to the next turn.\n\n• The attacker\'s attack fleet will face the planet defense fleet, the one who is left with no ships, loses the battle.\n\n• If the defender lost, the attacker gains control on that planet.',
  'Diplomacy-Determent':
      '• The bigger army you have, and the higher your fighting level is, the more the aliens will fear you.\n\n• The more they fear you the lower the chances they will dare to declare war on you. That\'s why it is important to build an army even if you\'re not planning an attack soon.\n\n• Notice: Some actions may cause a diplomatic crisis or cause an alien race to hate you so much that culture funds won\'t help in improving their attitude. In that case, the best you can do is to try to tackle them as quickly as possible.',
};
