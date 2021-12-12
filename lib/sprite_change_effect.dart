import 'package:flame/components.dart';
import 'package:flame/effects.dart';

/// Changes the sprite image of a [SpriteComponent].
/// This is used to change the ball's image on collision.
class SpriteChangeEffect extends ComponentEffect<SpriteComponent> {
  final Sprite sprite;
  late final Sprite? _original;

  SpriteChangeEffect(this.sprite, EffectController controller)
      : super(controller);

  @override
  Future<void> onMount() async {
    super.onMount();

    if (target.sprite != null && target.sprite?.image != null) {
      _original = Sprite(target.sprite!.image);
    }
  }

  @override
  void apply(double progress) {
    // since we don't apply anything progressively, there is only 0.0 and 1.0
    // for us
    // if you wanted to gradually change the sprite by applying a transparency,
    // you could do this here
    target.sprite = progress == 0.0 ? _original : sprite;
    super.apply(progress);
  }

  /// We need these methods to check if we already applied an effect to our ball.
  bool operator ==(o) => o is SpriteChangeEffect && o.sprite.src == sprite.src;
  int get hashCode => sprite.src.hashCode;
}
