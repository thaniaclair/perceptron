# ***********************************************************
# * Rede Neural Artificial para Reconhecimento do OU Lógico *
# ***********************************************************
# Autores: Fabíola Macedo
#          Markus Eller
#          Rodrigo Dias
#          Thânia Clair
# ***********************************************************
module AI

  # Nome da classe do que contém a lógica de treinamento do perceptron.
  class Perceptron

    # Criando dois símbolos para a época corrente e os pesos para torná-los acessíveis para leitura.
    attr_reader :curr_epoch, :weights
    # Criando símbolos para os eventos.
    attr_accessor :on_each_epoch, :on_trained

    # Método que inicializa a rede.
    def initialize(epochs, weights, threshold = 1, bias = false)
      # Inicializando atributos 
      @max_epochs = epochs
      @weights = weights
      @threshold = threshold
      @bias = bias
      @curr_epoch = 0
      # Inicializando os padrões 
      @numbers = []
      @numbers << NetworkNumber.new([0, 0], 0)
      @numbers << NetworkNumber.new([0, 1], 1)
      @numbers << NetworkNumber.new([1, 0], 1)
      @numbers << NetworkNumber.new([1, 1], 1)
    end

    # Método que treina a rede.
    def train
      
      # A flag aqui é ter alcançado o número de épocas desejado pelo usuário
      # ou a rede estar treinada.
      while ((@curr_epoch < @max_epochs) && (not trained?))
	# Incrementa uma época  
        @curr_epoch += 1
        # Chama o evento que ocorre a cada época 
        @on_each_epoch.call(@curr_epoch, @weights) if @on_each_epoch.respond_to?(:call)
        # Iteração sobre cada padrão
        @numbers.each do |number|
            # Pega o valor net na situação atual
	    net = net(number) 
            # Pega o valor Y retornado pela função de ativação 
            # ao passar o valor do net 
	    y = activation(net)
            # Para saber se devemos aumentar ou diminuir
            # os pesos, fazemos essa verificação do valores Y
	    sign = 0
            # Neste caso os pesos devem ser aumentados 
	    if y < number.y
		sign = 1
	    # Neste caso os pesos devem ser diminuídos
	    elsif y > number.y
		sign = -1
	    # Neste caso a rede está treinado e o peso 
	    # não precisa ser ajustado
	    else
		next
	    end
            # Ajustando os pesos
	    @weights.length.times do |i|
                @weights[i] += number.pattern[i] * sign
            end
        end
      end
      # Chama o evento que ocorre após o treinamento
      @on_trained.call(@curr_epoch, @weights) if trained? && @on_each_epoch.respond_to?(:call)
    end

    # Método que verifica se a rede perceptron está treinada.
    def trained?
      @numbers.each do |number|
        net = net(number)
        y = activation(net)
        return false if y != number.y
      end
      true
    end
    
    # Método que retorna true se o num é maior ou igual ao limiar,
    # falso caso contrário.
    def activation(num)
      (num >= @threshold) ? 1 : 0
    end

    # Método que retorna o valor do net da rede.
    def net(number)
      sum = 0
      @weights.length.times do |i|
        sum += @weights[i] * number.pattern[i]
      end
      sum
    end

  end

  # Classe que representa um padrão a ser treinado.
  class NetworkNumber

    attr_accessor :pattern
    attr_reader :y

    # Método que inicializa o número da rede.
    def initialize(pattern, y)
      @pattern = pattern
      @y = y
    end

  end

end
