# ***********************************************************
# * Rede Neural Artificial para Reconhecimento do OU Lógico *
# ***********************************************************
# Autores: Fabíola Macedo
#          Markus Eller
#          Rodrigo Dias
#          Thânia Clair
# ***********************************************************

#!/usr/bin/env ruby
$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

# Bibliotecas importadas
require 'perceptron'
require 'optparse'

# Valores default
options = {}

# Número de épocas 
options[:max_epochs] = 20 
# Pesos 
options[:weights] = [0, 0] 
# Bias
options[:bias] = false 
# Limiar ou threshold
options[:threshold] = 1  
# Flag para o tipo de saída
options[:verbose] = true 

# Opções de parâmetros 
OptionParser.new do |opts|

    # A versão do nosso programa
    opts.version = '0.3'
    # O nome do projeto
    opts.program_name = 'RubyORPerceptron' 

    # Este parâmetro mostra o HELP/AJUDA do sistema
    opts.on("-h", "--help", "Show this message") do
	puts opts
	exit
    end

    # Este parâmetro mostra a versão do sistema 
    opts.on("-v", "--version", "Show version") do
	puts opts.version
	exit
    end

    # Este parâmetro serve para passar o número de épocas desejado pelo usuário
    opts.on("-e INTEGER", "--maxepochs INTEGER", Integer, "Maximum number of training epochs (defaults to #{options[:max_epochs]}).") do |v|
	options[:max_epochs] = v
    end

    # Este parâmetro serve para passar o peso sináptico 1
    opts.on("-a", "--weight1 FLOAT", Float, "Value of weight 1 (defaults to #{options[:weights][0]}).") do |v|
	options[:weights][0] = v
    end
    
    # Este parâmetro serve para passar o peso sináptico 2 
    opts.on("-b", "--weight2 FLOAT", Float, "Value of weight 2 (defaults to #{options[:weights][1]}).") do |v|
	options[:weights][1] = v
    end

    # Este parâmetro serve para solicitar o uso do neurônio de viés ou bias
    opts.on("-i", "--bias", "Include the bias neuron") do
	options[:bias] = true
    end

    # Este parâmetro serve para passar o valor do threshold ou limiar
    opts.on("-t", "--threshold INTEGER", Integer, "Value of threshold (defaults to #{options[:threshold]}).") do |v|
	options[:threshold] = v
    end

    # Este parâmetro serve para solicitar que a saída seja simplificada
    opts.on("-q", "--quiet", "Supress normal output") do
	options[:verbose] = false
    end

end.parse! # Chama aqui o método parse de forma destrutiva

# Instancia o nosso perceptron passando os parâmetros passados pelos usuário - caso contrário são os defaults.
perceptron = AI::Perceptron.new(options[:max_epochs], options[:weights], options[:threshold], options[:bias])

# É uma saída verbose/simplicada? 
if options[:verbose]
  
  puts "Starting training..."

  # Evento para cada época
  perceptron.on_each_epoch = Proc.new do |epoch, weights|
    puts "#{epoch}) Perceptron not trained yet (#{weights.join(', ')})."
  end

  # Evento para o momento em que a rede foi treinada
  perceptron.on_trained = Proc.new do |epoch, weights|
    puts " * #{epoch}) Perceptron now trained (#{weights.join(', ')}). * "
  end
end

# Manda o perceptron treinar
perceptron.train

# Mostra os resultados 
puts "Results..."

# A rede conseguir ser treinada?
if perceptron.trained?
  puts "Perceptron successfully trained in #{perceptron.curr_epoch} epochs."
else
  puts "Perceptron couldn't be trained in #{perceptron.curr_epoch} epochs."
end
