import 'package:flame/components.dart';
import 'package:flame/effects.dart';

/// Changes the sprite image of a [SpriteComponent].
/// This is used to change the ball's image on collision.
class SpriteChangeEffect extends ComponentEffect<SpriteComponent> {
  final Sprite sprite;
  late final Sprite _original;

  SpriteChangeEffect(this.sprite, EffectController controller)
      : super(controller);

  @override
  Future<void> onMount() async {
    super.onMount();

    _original = Sprite(target.sprite!.image);
  }

  @override
  void apply(double progress) {
    // we only have two states 1.0 and 0.0
    // if you wanted to gradually change the sprite by applying a transparency,
    // you could do this here by taking everything between 1.0 and 0.0
    // into account
    target.sprite = progress == 0.0 ? _original : sprite;
    super.apply(progress);
  }

  /// We need these methods to check if we already applied an effect to our ball.
  bool operator ==(o) => o is SpriteChangeEffect && o.sprite.src == sprite.src;
  int get hashCode => sprite.src.hashCode;
}
