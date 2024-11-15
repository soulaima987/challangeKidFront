<?php

namespace App\Entity;

use App\Repository\KidParentRepository;
use Doctrine\ORM\Mapping as ORM;


#[ORM\Entity(repositoryClass: KidParentRepository::class)]
class KidParent extends User
{

    #[ORM\OneToOne(cascade: ['persist', 'remove'])]
    #[ORM\JoinColumn(nullable: false)]
    private ?Kid $kid = null;

    public function getKid(): ?Kid
    {
        return $this->kid;
    }

    public function setKid(Kid $kid): static
    {
        $this->kid = $kid;

        return $this;
    }

    public function getRoles(): array
    {
        return ['ROLE_PARENT'];
    }

    public function getUserIdentifier(): string
    {
        return $this->email;
    }
}
