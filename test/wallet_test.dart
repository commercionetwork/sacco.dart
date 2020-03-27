import 'dart:convert';

import 'package:hex/hex.dart';
import 'package:sacco/sacco.dart';
import 'package:test/test.dart';

void main() {
  final networkInfo = NetworkInfo(bech32Hrp: "cosmos", lcdUrl: "");

  // Generated using the default 'derivation path'
  final testVectors1 = {
    "cosmos1huydeevpz37sd9snkgul6070mstupukw00xkw9":
        "final random flame cinnamon grunt hazard easily mutual resist pond solution define knife female tongue crime atom jaguar alert library best forum lesson rigid",
    "cosmos12lla7fg3hjd2zj6uvf4pqj7atx273klc487c5k":
        "must lottery surround bike cash option split aspect cram volume repeat goose enemy mouse ostrich crowd thing huge fiscal fuel canal tuna hair educate",
    "cosmos1wclftxxzt2sshqz0xtq4rxtk82wawyg6y2uafs":
        "pencil flat shed laundry idle phone glow hint dilemma roast bulb shop spice birth rigid project bar night song pluck then illegal obvious syrup",
    "cosmos1sc0ppj28frtyeqgs9gjk39lfd78507s3cu9e5k":
        "embrace subway again gift toilet price security ordinary zoo owner orbit age destroy invest little scheme crumble leisure remove muffin shoe deliver defy draw",
    "cosmos1l8yr93zkltwzdphd8g6073jgxslmf2pax7ml77":
        "garage jungle error orient puzzle crater cancel walk tissue fence dynamic bean aisle ring adult truth dog chapter claw six exhaust soda planet cycle",
    "cosmos1gmf3mqgxy6s89ac0n2uwxaw7ax5js88e7a5jgh":
        "seven confirm glass lawsuit flower test power rain animal argue fetch play local erupt curious certain february hover zone carpet pipe alarm capable box",
    "cosmos17c7nap702zdjwlqu6aystxy23kk252my4gkkfp":
        "minor craft between drive depart endorse fresh blade drill help skull hub evolve door sea comic pulse chicken awesome rebel leave series live brain",
    "cosmos1m87tazfksqu8d6cxwaexzg2e7w9a5q9nwjt2sc":
        "hurdle satisfy excess hub month great ordinary crane begin laugh evoke domain humor absent dawn blanket prefer ice ripple auto boost vast version soup",
    "cosmos1ase8zsfkqgvxw8yynfklq73u5utff0xxyzam58":
        "pipe apple lobster gadget front cloud reject whip village idle ready concert general scrub silver neutral crop oyster tackle enlist winner milk duty tomato",
    "cosmos1vwf547ntuvt69u46vzyzwwffmuxyhx9c7kx7st":
        "solve retire concert illegal garage recall skill power lyrics bunker vintage silver situate gadget talent settle left snow fire bubble bar robot swing senior"
  };

  // Generated using a 'derivation path' that ends with 1
  final testVectors2 = {
    "cosmos1q6yq3vrv5f6l8sk8k6kgj5tkepvmtj4whu7h2k":
        "final random flame cinnamon grunt hazard easily mutual resist pond solution define knife female tongue crime atom jaguar alert library best forum lesson rigid",
    "cosmos14j0fjpffgyu2swkwtyht4sgaclxyexkdp9n5ph":
        "must lottery surround bike cash option split aspect cram volume repeat goose enemy mouse ostrich crowd thing huge fiscal fuel canal tuna hair educate",
    "cosmos10tk3v8kqc80jrhjslr9wntmejf5f9vrkxgg04u":
        "pencil flat shed laundry idle phone glow hint dilemma roast bulb shop spice birth rigid project bar night song pluck then illegal obvious syrup",
    "cosmos152a23p6h3txkealspwm99npv83dnaqputx66ak":
        "embrace subway again gift toilet price security ordinary zoo owner orbit age destroy invest little scheme crumble leisure remove muffin shoe deliver defy draw",
    "cosmos1ltxdweu3jk8w8l9tgsr82ppkvkur0czrzchnd0":
        "garage jungle error orient puzzle crater cancel walk tissue fence dynamic bean aisle ring adult truth dog chapter claw six exhaust soda planet cycle",
    "cosmos1t6fm3r9nyuzsys3yumhdt02k39fchqu284mtae":
        "seven confirm glass lawsuit flower test power rain animal argue fetch play local erupt curious certain february hover zone carpet pipe alarm capable box",
    "cosmos1dw73dk53kkws0mes3h93sjrjn3jjp5nny8rgk5":
        "minor craft between drive depart endorse fresh blade drill help skull hub evolve door sea comic pulse chicken awesome rebel leave series live brain",
    "cosmos1sealpst3ge9d7x60wp0ne2dmefv89m6guv63q5":
        "hurdle satisfy excess hub month great ordinary crane begin laugh evoke domain humor absent dawn blanket prefer ice ripple auto boost vast version soup",
    "cosmos1rhk3la5zc0ntcehdvkf7f8x6ewjw02v2zuv2sy":
        "pipe apple lobster gadget front cloud reject whip village idle ready concert general scrub silver neutral crop oyster tackle enlist winner milk duty tomato",
    "cosmos17r94720wt2ymddvx9guettljljf59zyh97t4mf":
        "solve retire concert illegal garage recall skill power lyrics bunker vintage silver situate gadget talent settle left snow fire bubble bar robot swing senior"
  };

  test('Wallets are generated correctly', () {
    testVectors1.forEach((address, mnemonicString) {
      final mnemonic = mnemonicString.split(" ");
      final wallet = Wallet.derive(mnemonic, networkInfo);
      expect(wallet.bech32Address, address);
    });
  });

  test('Wallets are generated correctly using another derivation path', () {
    testVectors2.forEach((address, mnemonicString) {
      final mnemonic = mnemonicString.split(" ");
      final wallet =
          Wallet.derive(mnemonic, networkInfo, lastDerivationPathSegment: '1');
      expect(wallet.bech32Address, address);
    });
  });

  test('toJson and fromJson work properly', () {
    final mnemonic =
        "final random flame cinnamon grunt hazard easily mutual resist pond solution define knife female tongue crime atom jaguar alert library best forum lesson rigid"
            .split(" ");
    final wallet = Wallet.derive(mnemonic, networkInfo);

    final jsonWallet = wallet.toJson();

    final privateKey = wallet.privateKey;
    final retrievedWallet = Wallet.fromJson(jsonWallet, privateKey);

    expect(wallet, retrievedWallet);
  });

  test('sign generates non deterministic signatures', () {
    final info = NetworkInfo(bech32Hrp: "did:com:", lcdUrl: "");
    final mnemonic = [
      "will",
      "hard",
      "topic",
      "spray",
      "beyond",
      "ostrich",
      "moral",
      "morning",
      "gas",
      "loyal",
      "couch",
      "horn",
      "boss",
      "across",
      "age",
      "post",
      "october",
      "blur",
      "piece",
      "wheel",
      "film",
      "notable",
      "word",
      "man"
    ];
    final wallet = Wallet.derive(mnemonic, info);

    final data = "Test";
    final sig1 = HEX.encode(
      wallet.sign(
        utf8.encode(data),
      ),
    );
    final sig2 = HEX.encode(
      wallet.sign(
        utf8.encode(data),
      ),
    );
    expect(sig1 == sig2, false);
  });
}
