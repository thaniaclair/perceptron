# ***********************************************************
# * Rede Neural Artificial para Reconhecimento do OU Lógico *
# ***********************************************************
# Autores: Fabíola Macedo
#          Markus Eller
#          Rodrigo Dias
#          Thânia Clair
# ***********************************************************
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'test/unit'
require 'perceptron'

# Classe de testes da Rede Perceptron
class TestPerceptron < Test::Unit::TestCase

  # Testando a função de ativação
  def test_activation
    perceptron = AI::Perceptron.new(1, [-4, -3])
    assert_equal(1, perceptron.activation(3))
    assert_equal(0, perceptron.activation(0))
  end
 
  # Testando a função net
  def test_net
    perceptron = AI::Perceptron.new(1, [-2, -3])
    number = AI::NetworkNumber.new([1, 1], 1)
    assert_equal(-5, perceptron.net(number))
  end

  # Testando a função train
  def test_train
    perceptron = AI::Perceptron.new(1, [-4, -3])
    perceptron.train
    assert_equal(false, perceptron.trained?)
    assert_equal([-2, -1], perceptron.weights)

    perceptron = AI::Perceptron.new(1, [0, 0])
    perceptron.train
    assert_equal(true, perceptron.trained?)
    assert_equal([1, 1], perceptron.weights)

    perceptron = AI::Perceptron.new(2, [-1, -2])
    perceptron.train
    assert_equal(true, perceptron.trained?)
    assert_equal([1, 1], perceptron.weights)
  end

  # Testando a função trained
  def test_trained?
    perceptron = AI::Perceptron.new(10, [-1, -1])
    assert_equal(false, perceptron.trained?)
    perceptron = AI::Perceptron.new(10, [1, 1])
    assert_equal(true, perceptron.trained?)
  end

end
