<?php

namespace App\Form;

use App\Entity\Kid;
use App\Entity\KidResponse;
use App\Entity\Option;
use App\Entity\Quiz;
use App\Entity\Response;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

class ResponseType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder;
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults([
            'data_class' => KidResponse::class,
        ]);
    }
}
