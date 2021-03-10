load "Grille.rb"

##
# Représentation d'un écran de jeu, une partie de fill a pix
##
# * +win+               La fenêtre graphique du programme
# * +layoutManager+     Le layout principal pour le placement dans la fenetre
class Ecran_jeu

    ##
    # Constructeur de la classe
    ##
    # * +win+   La fenetre de l'application
    def Ecran_jeu.creer(win)
        new(win)
    end
    private_class_method :new

    ##
    # Placement et chargement des objets de l'écran, connection des signaux
    ##
    # * +win+   La fenetre de l'application
    def initialize(win)
        @win = win

        @layoutManager = Gtk::Box.new(:vertical, 5)
        espaceJeu = Gtk::Box.new(:horizontal, 5)

        grille = Grille_jeu.new()
        textfield1 = Gtk::Label.new("")
        textfield2 = Gtk::Label.new("")
        textfield1.set_size_request(350, 200) 

        @quit = Gtk::Button.new(:label => "Quitter")
        

        @quit.signal_connect("clicked"){
            vers_menu()
        }

        espaceJeu.add(textfield1)
        espaceJeu.add(grille.grille)
        espaceJeu.add(textfield2)

        #espaceJeu.set_homogeneous true

        @layoutManager.add(espaceJeu)
        @layoutManager.add(@quit)
        @win.add(@layoutManager)

        @win.show_all
    end

    ##
    # Permet de passer à l'écran du menu
    def vers_menu()
        @win.remove(@layoutManager)
        @ecr  = Ecran_menu.creer(@win)
    end
end