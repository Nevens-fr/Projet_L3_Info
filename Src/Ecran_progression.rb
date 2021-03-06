##
# La classe qui gére l'affichage de la progression de l'utilisateur dans l'aventure
##
# * +win+               La fenêtre de l'application
# * +boite+             Le layout pour placer tous les boutons et afficher l'image de fond
# * +retourMenu+        Bouton permettant de retourner au menu principal
# * +map+               Nom du fichier de la grille utilisée
# * +chronoLabel+       Label contenant le temps total du joueur sur une grille en cours
# * +penalitesLabel+    Label contenant les pénalités du joueur sur une grille en cours
# * +grille+            La grille de jeu affichée
# * +nbLignes+          Le nombre de lignes du fichier
# * +file_data+         Les données du fichier
# * +i_chap+            Index du chapitre
class Ecran_progression
    
    ##
    # Constructeur de la classe
    ##
    # * +win+   La fenetre de l'application
    def Ecran_progression.creer(win)
        new(win)
    end

    private_class_method :new

    ##
    # Construction de l'instance
    ##
    # * +win+   La fenetre de l'application
    def initialize(win)

        # init des composants

        @win = win
        @map = "../Grilles/grille_chapitre1.txt"
        @boite = Gtk::Fixed.new()
        container = Gtk::Box.new(:vertical)

        @retourMenu = Gtk::Button.new(:label => "")
        defilerChapitres = Gtk::Button.new(:label => "")

        # Création tableau de boutons

        btnChapitre = [
            Gtk::Button.new(),
            Gtk::Button.new(),
            Gtk::Button.new(),
            Gtk::Button.new(),
            Gtk::Button.new()
        ]

        # Création tableau de labels

        lblChapitre = [
            Gtk::Label.new(""),
            Gtk::Label.new(""),
            Gtk::Label.new(""),
            Gtk::Label.new(""),
            Gtk::Label.new("")
        ]

        # Chargement background

        @boite.add(Gtk::Image.new(:file => "../maquettes/menu-progression.png"))
        container.add(@boite)

        # Création css texte labels
        cssChapitre = ajouteTexte(3)

        # Ajout des boutons dans la sidebar

        addChapitre(btnChapitre[0], lblChapitre[0], 13, 20, cssChapitre)
        addChapitre(btnChapitre[1], lblChapitre[1], 13, 155, cssChapitre)
        addChapitre(btnChapitre[2], lblChapitre[2], 13, 285, cssChapitre)
        addChapitre(btnChapitre[3], lblChapitre[3], 13, 420, cssChapitre)
        addChapitre(btnChapitre[4], lblChapitre[4], 13, 550, cssChapitre)

        # Ajout boutons retour vers menu et défiler chapitres

        ajouteBouton(@boite, defilerChapitres, 2, 45, 45, 230, 620, method(:actualiserChapitres), lblChapitre, nil)
        ajouteBouton(@boite, @retourMenu, 2, 60, 60, 20, 5, method(:vers_menu), @win, container)

        # Ajoute label pour chrono des grilles sauvegardées

        @chronoLabel = Gtk::Label.new("")
        ajouteTexteProvider(@chronoLabel, cssChapitre)
        @boite.put(@chronoLabel, 500, 615)

        @penalitesLabel = Gtk::Label.new("")
        ajouteTexteProvider(@penalitesLabel, cssChapitre)
        @boite.put(@penalitesLabel, 960, 615)


        @win.add(container)

        # Chargement de la grille 1

        if (Grille_jeu_charger.exist?(@map, 'Aventure'))
            @grille = Grille_jeu_charger.creer(false, Array.new, @map, nil, 'Aventure')
            @chronoLabel.label = @grille.getChrono()
            @penalitesLabel.label = @grille.getPenalites()
        else
            @grille = Grille_jeu.creer(false, nil, @map)
            @chronoLabel.label = "0' 0''"
            @penalitesLabel.label = "0' 0''"
        end
        @boite.put(@grille.grille, ($widthEcran *0.37), $heightEcran * 0.16)

        file = File.open("chapitres.txt")
        lignes = file.readlines
        @nbLignes = lignes.size
        @file_data = lignes.map(&:chomp)

        file.close

        @i_chap = 0

        # Placement des bons labels de chapitres
        actualiserChapitres(lblChapitre)

        @win.show_all
        Gtk.main

        return self
    end

    ##
    # Ajoute un chapitre dans la boite
    ##
    # * +bouton+ Le bouton contenant le label
    # * +label+  Le label à styliser
    # * +css+    Le css a appliquer
    # * +x+      Position en abscisse
    # * +y+      Postion en ordonnée
    def addChapitre(bouton, label, x, y, css) 
        ajouteBouton(@boite, bouton, 3, 260, 115, x, y, method(:eventChangerChapitre), label, nil)
        
        ajouteTexteProvider(label, css)
        bouton.add(label)
        return self
    end

    ##
    # Change la grille en fonction du chapitre sélectionné
    # * +label+ label du chapitre cliqué
    def eventChangerChapitre(label)
        #Cherche le numéro du chapitre sélectionné dans le label
        @boite.remove(@grille.grille)
        @map = "../Grilles/grille_chapitre" + label.label.gsub(/[^0-9]/, '') + ".txt"
        if (Grille_jeu_charger.exist?(@map, 'Aventure'))
            @grille = Grille_jeu_charger.creer(false, Array.new, @map, nil, 'Aventure')
            @chronoLabel.label = @grille.getChrono()
            @penalitesLabel.label = @grille.getPenalites()
        else
            @grille = Grille_jeu.creer(false, nil, @map)
            @chronoLabel.label = "0' 0''"
            @penalitesLabel.label = "0' 0''"
        end

        if (@grille.nbLignes == 10)
            @boite.put(@grille.grille, ($widthEcran *0.37), $heightEcran * 0.16)
        elsif (@grille.nbLignes == 15)
            @boite.put(@grille.grille, ($widthEcran *0.36), $heightEcran * 0.16)
        else
            @boite.put(@grille.grille, ($widthEcran *0.35), $heightEcran * 0.11)
        end

        @win.show_all
        return self
    end

    ##
    # Permet de changer les chapitres à l'appuie de la flèche
    # * +lblChapitre+ Liste des labels à actualiser
    def actualiserChapitres(lblChapitre)
        lblChapitre.each {|lbl| lbl.label = nextChapitre() }
           
        return self
    end

    ##
    # Charge le texte d'un chapitre dans le label
    def nextChapitre()
        until (@file_data[@i_chap].gsub("    ", "").start_with?("Chapitre"))
            @i_chap += 1

            if @i_chap == @nbLignes
                @i_chap = 0
            end
        end
        str = @file_data[@i_chap].gsub("    ", "").gsub(": ", "\n")
        if (str.size > 27)
            str = str[0...-9] + "..."
        elsif (str.size < 23)
            spaces = "";
            0.upto((14 - (str.size - 10)) / 2 ) { spaces += " " }
              
            str.insert(12, '♦')
            str = str.gsub("♦", spaces)
        end

        @i_chap += 1
        return "  " + str
    end

end